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
    
    @NSManaged var noiseLevel: NSNumber
    @NSManaged var freeWifi: NSNumber
    @NSManaged var wifiStrength: NSNumber
    @NSManaged var seatingAvailability: NSNumber
    @NSManaged var id: String
    @NSManaged var workThereAgain: NSNumber
    @NSManaged var notes: String
    @NSManaged var location: Location
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(noise: NSNumber, freeWifi: Bool, wifiStrength: Double, seatingAvailabilityRating: Double, wouldWorkThereAgain: Bool, notes: String, location: Location, context: NSManagedObjectContext){
        let entity =  NSEntityDescription.entityForName("Rating", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        id = NSUUID().UUIDString
        self.noiseLevel = noise
        self.freeWifi = NSNumber(bool: freeWifi)
        self.wifiStrength = wifiStrength
        self.seatingAvailability = seatingAvailabilityRating
        self.workThereAgain = NSNumber(bool: wouldWorkThereAgain)
        self.notes = notes
        self.location = location
    }
}