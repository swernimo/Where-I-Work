//
//  LocationHelper.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/8/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import CoreData


class LocationHelper {
    func getLocations(latitude: Double, longitude: Double, completionHandler: (locations: [Location], error: NSError?) -> Void) -> Void{
        var locations: [Location] = []
        
        locations.appendContentsOf(loadFromCoreData())
        loadFromYelp(latitude, long: longitude) {
            (results, error) in
            
            if(error == nil && results.count > 0){
                locations.appendContentsOf(results)
            }
            
            completionHandler(locations: locations, error: error)
        }
    }
    
    func loadFromCoreData() -> [Location]{
        let locCoreData = LocationCoreData()
        
        return locCoreData.loadSavedLocations()
    }
    
    func loadFromYelp(lat: Double, long: Double, completionHandler: (locations: [Location], error: NSError?) -> Void) {
        
        YelpClient.sharedInstance.getLocations(lat, longitude: long) {
            (locations, error) in
            
            completionHandler(locations: locations, error: error)
        }
    }
}