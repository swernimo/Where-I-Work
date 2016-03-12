//
//  LocationDisabledViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/12/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import MapKit

class LocationDisabledViewController: UIViewController, CLLocationManagerDelegate{
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch(status){
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            performSegueWithIdentifier("mapViewSegue", sender: nil)
            break
        default:
            break
        }
    }
}