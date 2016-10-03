//
//  Location.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/10/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//


class Location {
    
    var latitude: Double
    var longitude: Double
    var id: String
    var businessName: String
    var address: Address?
    var website: String?
    var category: String
    var phone: String?
    

    
    init(id: String, lat: Double, long: Double, name: String, adr: Address?, url: String?, category: String, phoneNumber: String?){
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
