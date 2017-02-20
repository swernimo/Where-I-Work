//
//  LocationDisabledViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/12/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import MapKit

class LocationDisabledViewController: BaseViewController{
    
    override func viewDidLoad() {
        setupLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if((status == .authorizedAlways) || (status == .authorizedWhenInUse)){
            dismiss(animated: false, completion: nil)
        }
    }
}
