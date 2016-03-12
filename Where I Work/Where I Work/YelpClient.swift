//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
// https://github.com/codepath/ios_yelp_swift/blob/master/Yelp/YelpClient.swift

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
    func getLocations(latitude: Double, longitude: Double, completionHandler: (locations: [Location], error: NSError?) -> Void) -> Void{

        var params: [String: AnyObject] = [:]
        
        params["ll"] = latitude.description + "," + longitude.description
        params["filter_category"] = "coffee,libraries"
        params["limit"] = 20
        params["radius_filter"] = 5000
//        params["term"] = "coffee"
        params["sort"] = YelpSortMode.Distance.rawValue
        
        print(params)
        
        self.GET("search", parameters: params, success: {
            (operation, response) in
            
            guard let businesses = response["businesses"] as? [NSDictionary] else{
                completionHandler(locations: [], error: NSError(domain: "YelpClient", code: -1, userInfo: ["Description": ""]))
                return
            }
            
            
            },
            failure: { (operation, error) in
                completionHandler(locations: [], error: error)
        })
    }
}