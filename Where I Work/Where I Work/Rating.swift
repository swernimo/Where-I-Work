//
//  Rating.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/23/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import CoreData

@objc(Rating)
class Rating: NSManagedObject{
    
    @NSManaged var noiseLevel: Double
    @NSManaged var freeWifi: Bool
    @NSManaged var wifiStrength: Double
    @NSManaged var seatingAvailability: Double
    @NSManaged var id: String
    @NSManaged var workThereAgain: Bool
    @NSManaged var notes: String
    @NSManaged var location: Location
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(noise: Double, freeWifi: Bool, wifiStrength: Double, seatingAvailabilityRating: Double, wouldWorkThereAgain: Bool, notes: String, location: Location, context: NSManagedObjectContext){
        let entity =  NSEntityDescription.entityForName("Rating", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        id = NSUUID().UUIDString
        noiseLevel = noise
        self.freeWifi = freeWifi
        self.wifiStrength = wifiStrength
        seatingAvailability = seatingAvailabilityRating
        self.workThereAgain = wouldWorkThereAgain
        self.notes = notes
        self.location = location
    }
}