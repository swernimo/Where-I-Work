//
//  GoogleClient.swift
//  Where I Work
//
//  Created by Sean Wernimont on 5/30/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

//import Foundation
import GoogleMaps
//import AFNetworking
//import BDBOAuth1Manager

class GoogleClient{
//    var placesClient: GMSPlacesClient
    class var sharedInstance : GoogleClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : GoogleClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = GoogleClient()
        }
        return Static.instance!
    }
    
    func getCurrentPlace(completionHandler: (GMSPlaceLikelihoodList?, error: NSError?) -> Void){
        let placesClient = GMSPlacesClient()
        placesClient.currentPlaceWithCallback(completionHandler)
    }
    
    func searchForPlace(latiude: Double, longitude: Double, completionHandler: (place: GMSPlace?, error: NSError?) -> Void){
        
        let center = CLLocationCoordinate2DMake(latiude, longitude)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.01, center.longitude + 0.01)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.01, center.longitude - 0.01)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlaceWithCallback(completionHandler)
    }
}