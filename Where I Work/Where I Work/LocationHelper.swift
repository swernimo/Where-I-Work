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
    func getLocations(latitude: Double, longitude: Double, callYelp: Bool, completionHandler: (locations: [Location], error: NSError?) -> Void) -> Void{
        var locations: [Location] = []
        var error: NSError? = nil
        locations.appendContentsOf(loadFromCoreData())
        if(callYelp){
            
            loadFromYelp(latitude, long: longitude, savedLocations: locations) {
                (results, err) in
                
                if(err == nil && results.count > 0){
                    locations.appendContentsOf(results)
                }
                error = err
                completionHandler(locations: locations, error: error)
            }
        }else{
            completionHandler(locations: locations, error: error)
        }
    }
    
    func loadFromCoreData() -> [Location]{
        let locCoreData = LocationCoreData()
        var saved = locCoreData.loadSavedLocations()
        saved = removeDuplicateLocations(saved)
        return saved
    }
    
    func removeDuplicateLocations(locationArray: [Location]) -> [Location]{
        var noDuplicates: [Location] = []
        if(locationArray.isEmpty == false){
            for index in 0 ... (locationArray.count - 1){
                let location = locationArray[index]
                let contains = noDuplicates.contains({ $0.businessName == location.businessName && $0.longitude == location.longitude && $0.latitude == location.latitude})
                if(contains == false){
                    noDuplicates.append(location)
                }
            }
        }
        return noDuplicates
    }
    
    func loadFromYelp(lat: Double, long: Double, savedLocations: [Location], completionHandler: (locations: [Location], error: NSError?) -> Void) {
        
        YelpClient.sharedInstance.getLocations(lat, longitude: long, savedLocations: savedLocations) {
            (locations, error) in
            
            completionHandler(locations: locations, error: error)
        }
    }
}