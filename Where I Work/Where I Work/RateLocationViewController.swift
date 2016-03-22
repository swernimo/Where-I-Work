//
//  RateLocationViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/7/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class RateLocationViewController : UIViewController, CLLocationManagerDelegate{
    var location: Location? = nil
    
    override func viewDidLoad() {
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch(status){
        case .NotDetermined, .Restricted, .Denied:
            performSegueWithIdentifier("locationNotAuthorizedSegue", sender: nil)
            break
        default:
            break
        }
        
    }
}