//
//  Location.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/10/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Location)
class Location: NSManagedObject {
    
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var id: String
    @NSManaged var businessName: String
    @NSManaged var address: Address?
    @NSManaged var website: String?
    @NSManaged var category: String
    @NSManaged var phone: String?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(id: String, lat: Double, long: Double, name: String, adr: Address?, url: String?, category: String, phoneNumber: String?, context: NSManagedObjectContext){
        let entity =  NSEntityDescription.entityForName("Location", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        latitude = lat
        longitude = long
        self.id = id
        businessName = name
        address = adr
        website = url
        self.category = category
        phone = phoneNumber
    }
}