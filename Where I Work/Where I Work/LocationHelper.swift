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
    
    func getLocations(_ latitude: Double, longitude: Double, callYelp: Bool, completionHandler: @escaping (_ locations: [Location], _ error: NSError?) -> Void) -> Void{
        var locations: [Location] = []
        var error: NSError? = nil
        if(callYelp){
            
            loadFromYelp(latitude, long: longitude, savedLocations: locations) {
                (results, err) in
                
                if(err == nil && results.count > 0){
                    locations.append(contentsOf: results)
                }
                error = err
                completionHandler(locations, error)
            }
        }else{
            completionHandler(locations, error)
        }
    }
    
    func getLocations(_ boundingBox: BoundingBox, callYelp: Bool, completionHandler: @escaping (_ locations: [Location], _ error: NSError?) -> Void) -> Void{
        var locations: [Location] = []
        var error: NSError? = nil
        if(callYelp){
            
            loadFromYelp(boundingBox, savedLocations: locations) {
                (results, err) in
                
                if(err == nil && results.count > 0){
                    locations.append(contentsOf: results)
                }
                error = err
                completionHandler(locations, error)
            }
        }else{
            completionHandler(locations, error)
        }
    }
    
    func removeDuplicateLocations(_ locationArray: [Location]) -> [Location]{
        var noDuplicates: [Location] = []
        if(locationArray.isEmpty == false){
            for index in 0 ... (locationArray.count - 1){
                let location = locationArray[index]
                let contains = noDuplicates.contains(where: { $0.businessName == location.businessName && $0.longitude == location.longitude && $0.latitude == location.latitude})
                if(contains == false){
                    noDuplicates.append(location)
                }
            }
        }
        return noDuplicates
    }
    
    func loadFromYelp(_ lat: Double, long: Double, savedLocations: [Location], completionHandler: @escaping (_ locations: [Location], _ error: NSError?) -> Void) {
        
        YelpClient.sharedInstance.getLocations(lat, longitude: long, savedLocations: savedLocations) {
            (locations, error) in
            
            completionHandler(locations, error)
        }
    }
    
    func loadFromYelp(_ boudingBox: BoundingBox, savedLocations: [Location], completionHandler: @escaping (_ locations: [Location], _ error: NSError?) -> Void) {
        
        YelpClient.sharedInstance.getLocations(boudingBox, savedLocations: savedLocations) {
            (locations, error) in
            
            completionHandler(locations, error)
        }
    }
}
