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
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        setupLocationManager()
    }
    
    func setupLocationManager()->Void{
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if((status == .authorizedAlways) || (status == .authorizedWhenInUse)){
            dismiss(animated: false, completion: nil)
        }
    }
}
