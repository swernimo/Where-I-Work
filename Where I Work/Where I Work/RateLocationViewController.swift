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
    
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var noiseLevelStepper: UIStepper!
    @IBOutlet weak var noiseLevelLabel: UILabel!
    @IBOutlet weak var freeWifiSwitch: UISwitch!
    @IBOutlet weak var wifiStrengthStepper: UIStepper!
    @IBOutlet weak var wifiStrengthLabel: UILabel!
    @IBOutlet weak var seatingAvailabliityStepper: UIStepper!
    @IBOutlet weak var seatingAvailabiltyLabel: UILabel!
    @IBOutlet weak var workThereAgainSwitch: UISwitch!
    @IBOutlet weak var notesTextView: UITextView!
    
    
    override func viewDidLoad() {
        displayLocation()
    }
    
    func displayLocation(){
        if(location != nil){
            
        }
        else{
            hideControlsIfLocationIsNil()
        }
    }
    
    func hideControlsIfLocationIsNil(){
        
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
    
    @IBAction func cancelButton_Clicked(sender: UIBarButtonItem) {
        performSegueWithIdentifier("mapViewSegue", sender: nil)
    }

    @IBAction func saveButton_Clicked(sender: UIBarButtonItem) {
        //TODO: create new rating object
        //TODO: save to CoreData
        performSegueWithIdentifier("mapViewSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        location = nil
        hideControlsIfLocationIsNil()
    }
}