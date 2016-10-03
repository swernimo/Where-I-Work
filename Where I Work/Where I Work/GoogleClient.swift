//
//  GoogleClient.swift
//  Where I Work
//
//  Created by Sean Wernimont on 5/30/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import AFNetworking
import BDBOAuth1Manager

class GoogleClient{
    static let sharedInstance: GoogleClient = {
        let instance = GoogleClient()
        return instance
    }()
    
    func getCurrentPlace(_ completionHandler: @escaping (GMSPlaceLikelihoodList?, _ error: NSError?) -> Void){
        let placesClient = GMSPlacesClient()
        placesClient.currentPlace(callback: completionHandler as! GMSPlaceLikelihoodListCallback)
    }
    
    func searchForPlace(_ latiude: Double, longitude: Double, completionHandler: @escaping (_ place: GMSPlace?, _ error: NSError?) -> Void){
        
        let center = CLLocationCoordinate2DMake(latiude, longitude)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.01, center.longitude + 0.01)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.01, center.longitude - 0.01)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: completionHandler as! GMSPlaceResultCallback)
    }
}
