//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
// https://github.com/codepath/ios_yelp_swift/blob/master/Yelp/YelpClient.swift
// modified by Sean Wernimont

import UIKit

import AFNetworking
import BDBOAuth1Manager

let yelpConsumerKey = Constants.YelpKeys.ConsumerKey
let yelpConsumerSecret = Constants.YelpKeys.ConsumerSecret
let yelpToken = Constants.YelpKeys.Token
let yelpTokenSecret = Constants.YelpKeys.TokenSecret

enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpClient : BDBOAuth1RequestOperationManager {
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    var accessToken: String!
        var accessSecret: String!
    
        class var sharedInstance : YelpClient {
            struct Static {
                static var token : dispatch_once_t = 0
                static var instance : YelpClient? = nil
            }
    
            dispatch_once(&Static.token) {
                Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
            }
            return Static.instance!
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
        init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
            self.accessToken = accessToken
            self.accessSecret = accessSecret
            let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
            super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
    
            let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
            self.requestSerializer.saveAccessToken(token)
        }
    func getLocations(latitude: Double, longitude: Double, savedLocations: [Location], completionHandler: (locations: [Location], error: NSError?) -> Void) -> Void{

        var params: [String: AnyObject] = [:]
        
        params["ll"] = latitude.description + "," + longitude.description
        params["filter_category"] = "coffee,libraries"
        params["limit"] = 20
        params["radius_filter"] = 5000
        params["sort"] = YelpSortMode.Distance.rawValue
        
        self.GET("search", parameters: params, success: {
            (operation, response) in
            
            var locationArray: [Location] = []
            
            guard let businesses = response["businesses"] as? [NSDictionary] else{
                completionHandler(locations: [], error: self.createNSError("could not find businesses key in return"))
                return
            }
            
            for(_, bus) in businesses.enumerate(){
                guard let name = bus["name"] as? String else{
                    completionHandler(locations: [], error: self.createNSError("could not business name"))
                    return
                }
                
                guard let location = bus["location"] as? NSDictionary else{
                    completionHandler(locations: [], error: self.createNSError("could not find location"))
                    return
                }
                
                guard let coordinate = location["coordinate"] as? NSDictionary else{
                    completionHandler(locations: [], error: self.createNSError("could not find coordinate within location"))
                    return
                }
                
                guard let lat = coordinate["latitude"] as? Double else{
                    completionHandler(locations: [], error: self.createNSError("could not find latitude within coordinate"))
                    return
                }
                
                guard let long = coordinate["longitude"] as? Double else{
                    completionHandler(locations: [], error: self.createNSError("could not find longitude within coordinate"))
                    return
                }
                
                guard let categoryArray = bus["categories"] as? [[String]] else{
                    completionHandler(locations: [], error: self.createNSError("could not find category array within business"))
                    return
                }
                
                var categoryName: String = ""
                
                for(_, category) in categoryArray.enumerate(){
                    if(category.contains("coffee")){
                        categoryName = "coffee"
                        break
                    }else if (category.contains("libraries")){
                        categoryName = "libraries"
                        break
                    }
                }
                
                let address = self.parseAddressFromLocationDictionary(location)
                let id = NSUUID().UUIDString
                let loc = Location(id: id, lat: lat, long: long, name: name, adr: address, url: nil, category: categoryName, context: self.sharedContext)
                
//                let locationAlreadySaved = self.locationAlreadySaved(loc, savedLocations: savedLocations)
//                if(locationAlreadySaved){
//                    continue
//                }else{
//                    CoreDataStackManager.sharedInstance().saveContext()
                    locationArray.append(loc)
//                }
                
            }
            if(NetworkHelper.isConnectedToNetwork()){
                completionHandler(locations: locationArray, error: nil)
            }
            else{
                completionHandler(locations: [], error: self.createNSError("Network Error"))
            }
            },
            failure: { (operation, error) in
                completionHandler(locations: [], error: error)
        })
    }
    
    func locationAlreadySaved(location: Location, savedLocations: [Location]) -> Bool{
        var saved = false
        if(savedLocations.isEmpty == false){
            for index in 0 ..< savedLocations.count{
                let loc = savedLocations[index]
                if(loc.businessName == location.businessName){
                    if(loc.latitude == location.latitude){
                        if(loc.longitude == location.longitude){
                            saved = true
                            break
                        }
                    }
                }
            }
        }
        return saved
    }
    
    func createNSError(errorDescription: String) -> NSError{
        return NSError(domain: "YelpClient", code: -1, userInfo: ["Description" : errorDescription])
    }
    
    func parseAddressFromLocationDictionary(dictionary: NSDictionary) -> Address?{
        guard let streetAddress = dictionary["address"] as? [String] else{
            return nil
        }
        
        if(streetAddress.isEmpty){
            return nil
        }
        
        let line1 = streetAddress[0]
        
        guard let postalCode = dictionary["postal_code"] as? String else{
            return nil
        }
        
        guard let state = dictionary["state_code"] as? String else{
            return nil
        }
        
        guard let city = dictionary["city"] as? String else{
            return nil
        }
        
        return Address(street: line1, city: city, zip: postalCode, state: state, context: sharedContext)
    }
}