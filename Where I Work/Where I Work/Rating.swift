//
//  Rating.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/23/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//
import Foundation

class Rating{
    
    var noiseLevel: Double
    var freeWifi: Bool
    var wifiStrength: Double
    var seatingAvailability: Double
    var id: String
    var workThereAgain: Bool
    var notes: String
    var location: Location
    var dateCreated: Date
    
    
    init(id: String, noise: Double, freeWifi: Bool, wifiStrength: Double, seatingAvailabilityRating: Double, wouldWorkThereAgain: Bool, notes: String, location: Location, created: Date){
        self.id = id
        self.noiseLevel = noise
        self.freeWifi = freeWifi
        self.wifiStrength = wifiStrength
        self.seatingAvailability = seatingAvailabilityRating
        self.workThereAgain = wouldWorkThereAgain
        self.notes = notes
        self.location = location
        self.dateCreated = created
    }
}
