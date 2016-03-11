//
//  Address.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/10/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import CoreData

@objc(Address)
class Address: NSManagedObject{
    
    @NSManaged var street: String
    @NSManaged var city: String
    @NSManaged var zipCode: String
    @NSManaged var id: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(street: String, city: String, zip: String, context: NSManagedObjectContext){
        let entity =  NSEntityDescription.entityForName("Address", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        id = NSUUID().UUIDString
        self.street = street
        self.city = city
        zipCode = zip
    }
}