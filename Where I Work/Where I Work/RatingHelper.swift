//
//  RatingHelper.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/23/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation

class RatingHelper{
    
    func getRatingForLocation(location: Location) -> Rating?{
        let rating = RatingCoreData()
        
        return rating.loadRatingForLocation(location)
    }
}