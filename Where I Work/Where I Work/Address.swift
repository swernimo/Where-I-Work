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
    @NSManaged var state: String
    @NSManaged var zipCode: String
    @NSManaged var id: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(street: String, city: String, zip: String, state: String, context: NSManagedObjectContext){
        let entity =  NSEntityDescription.entityForName("Address", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        id = NSUUID().UUIDString
        self.street = street
        self.city = city
        zipCode = zip
        self.state = state
    }
    
    func getAddressDisplayString() -> String{
        var addressString = ""
        addressString.appendContentsOf(street)
        addressString.appendContentsOf("\r\n")
        addressString.appendContentsOf(city)
        addressString.appendContentsOf(" ")
        addressString.appendContentsOf(state)
        addressString.appendContentsOf(", ")
        addressString.appendContentsOf(zipCode)
        return addressString
    }
}