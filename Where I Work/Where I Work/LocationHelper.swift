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
        
        /*
            TODO:
                Load data from YELP
                Load data from CoWorkingMap
        */
        
        var locations: [Location] = []
        
        locations.appendContentsOf(loadFromCoreData())
        loadFromYelp(latitude, long: longitude)
    }
    
    func loadFromCoreData() -> [Location]{
        let locCoreData = LocationCoreData()
        
        return locCoreData.loadSavedLocations()
    }
    
    func loadFromYelp(lat: Double, long: Double) {
        
        YelpClient.sharedInstance.getLocations(lat, longitude: long) {
            (locations, error) in
            print("I'm really tired and need to go to bed.")
        }
    }
}