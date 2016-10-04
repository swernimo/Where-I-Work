//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
// https://github.com/codepath/ios_yelp_swift/blob/master/Yelp/YelpClient.swift
// modified by Sean Wernimont

import UIKit
import CoreData
import AFNetworking
import BDBOAuth1Manager

let yelpConsumerKey = Constants.YelpKeys.ConsumerKey
let yelpConsumerSecret = Constants.YelpKeys.ConsumerSecret
let yelpToken = Constants.YelpKeys.Token
let yelpTokenSecret = Constants.YelpKeys.TokenSecret

enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated
}

class YelpClient : BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!

    static let sharedInstance: YelpClient = {
        let instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        return instance
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);

        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func getLocations(_ latitude: Double, longitude: Double, savedLocations: [Location], completionHandler: @escaping (_ locations: [Location], _ error: NSError?) -> Void) -> Void{

        var params = getParameterDictionary()
        var ll = String()
        ll = latitude.description
        ll += ","
        ll += longitude.description
        params["ll"] = ll as AnyObject? //latitude.description //+ ll + longitude.description
        
        searchYelp(params, completionHandler: completionHandler)
    }
    
    func getLocations(_ boundingBox: BoundingBox, savedLocations: [Location], completionHandler: @escaping (_ locations: [Location], _ error: NSError?) -> Void) -> Void{
        
        var params = getParameterDictionary()
        
        params["bounds"] = "\(boundingBox.SouthWest.latitude),\(boundingBox.SouthWest.longitude)|\(boundingBox.NorthEast.latitude),\(boundingBox.NorthEast.longitude)" as AnyObject?
        
        searchYelp(params, completionHandler: completionHandler)
    }
    
    func getParameterDictionary() -> [String: AnyObject]{
        var params: [String: AnyObject] = [:]
        
        params["category_filter"] = "coffee,libraries,internetcafe,cafes" as AnyObject?
        params["limit"] = 20 as AnyObject?
        params["radius_filter"] = 5000 as AnyObject?
        params["sort"] = YelpSortMode.distance.rawValue as AnyObject?
        
        return params
    }
    
    func locationAlreadySaved(_ location: Location, savedLocations: [Location]) -> Bool{
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
    
    func createNSError(_ errorDescription: String) -> NSError{
        return NSError(domain: "YelpClient", code: -1, userInfo: ["Description" : errorDescription])
    }
    
    func parseAddressFromLocationDictionary(_ dictionary: NSDictionary) -> Address?{
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
        
        return Address(street: line1, city: city, zip: postalCode, state: state)
    }
    
    fileprivate func searchYelp(_ params: [String:AnyObject], completionHandler: @escaping (_ locations: [Location], _ error: NSError?) -> Void) -> Void{
        self.get("search", parameters: params, success: {
            (operation, response) in
            
            var locationArray: [Location] = []
            
            guard let dictionary = response as? [String: AnyObject] else{
                completionHandler([], self.createNSError("could not convert response to dictionary array"))
                return
            }
            
            guard let businesses = dictionary["businesses"] as? [NSDictionary] else{
                completionHandler([], self.createNSError("could not find businesses key in return"))
                return
            }
            
            for(_, bus) in businesses.enumerated(){
                guard let name = bus["name"] as? String else{
                    completionHandler([], self.createNSError("could not business name"))
                    return
                }
                
                guard let location = bus["location"] as? NSDictionary else{
                    completionHandler([], self.createNSError("could not find location"))
                    return
                }
                
                guard let coordinate = location["coordinate"] as? NSDictionary else{
                    completionHandler([], self.createNSError("could not find coordinate within location"))
                    return
                }
                
                guard let lat = coordinate["latitude"] as? Double else{
                    completionHandler([], self.createNSError("could not find latitude within coordinate"))
                    return
                }
                
                guard let long = coordinate["longitude"] as? Double else{
                    completionHandler([], self.createNSError("could not find longitude within coordinate"))
                    return
                }
                
                guard let categoryArray = bus["categories"] as? [[String]] else{
                    completionHandler([], self.createNSError("could not find category array within business"))
                    return
                }
                
                guard let phone = bus["display_phone"] as? String else{
                    continue
                }
                
                guard let _ = bus["is_closed"] as? Bool else{
                    completionHandler([], self.createNSError("Business: \(name) is permanently closed."))
                    return
                }
                
                var categoryName: String = ""
                
                if(categoryArray.count > 0){
                    categoryName = categoryArray[0][0]
                }
                
                let address = self.parseAddressFromLocationDictionary(location)
                let id = UUID().uuidString
                let loc = Location(id: id, lat: lat, long: long, name: name, adr: address, url: nil, category: categoryName, phoneNumber: phone)
                locationArray.append(loc)
                
            }
            if(NetworkHelper.isConnectedToNetwork()){
                completionHandler(locationArray, nil)
            }
            else{
                completionHandler([], self.createNSError("Network Error"))
            }
            },
                 failure: { (op, error) in
                    let arr = [Location]()
                    completionHandler(arr, error as NSError?)
        })

    }

}
