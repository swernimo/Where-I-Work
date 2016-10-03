//
//  Address.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/10/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//
import Foundation

class Address{
    
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var id: String
    
    
    init(street: String, city: String, zip: String, state: String){
        id = UUID().uuidString
        self.street = street
        self.city = city
        zipCode = zip
        self.state = state
    }
    
    func getAddressDisplayString(_ includeNewLine: Bool) -> String{
        var addressString = ""
        addressString.append(street)
        if(includeNewLine){
            addressString.append("\r\n")
        }else{
            addressString.append(" ")
        }
        addressString.append(city)
        addressString.append(" ")
        addressString.append(state)
        addressString.append(", ")
        addressString.append(zipCode)
        return addressString
    }
}
