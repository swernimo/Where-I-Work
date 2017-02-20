//
//  BaseViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 2/19/17.
//  Copyright © 2017 Just One Guy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BaseViewController : UIViewController, CLLocationManagerDelegate{
    
    var locationManager: CLLocationManager!
    let hasNetworkConnection = NetworkHelper.isConnectedToNetwork()
    var locationAuthorized: Bool = true
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if(locationAuthorized == false){
            navigateToLocationDisabled()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLocationManager()
        switch(CLLocationManager.authorizationStatus()){
        case .notDetermined, .restricted, .denied:
            locationAuthorized = false
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationAuthorized = true
            break
        }
    }
    
    
    func showAlert(_ title: String, message: String){
        let alertview = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertview, animated: true, completion: nil)
    }
    
    func navigateToLocationDisabled(){
       performSegue(withIdentifier: "locationDisabledSegue", sender: nil)
    }
    
    func setupLocationManager()->Void{
        if(CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}
