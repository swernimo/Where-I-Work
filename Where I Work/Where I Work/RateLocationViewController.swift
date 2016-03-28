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
    var location: Location?
    
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
        if(location != nil){
            let rating = loadRating(location!)
            displayRatingIfExisting(rating)
        }
        notesTextView.layer.borderColor = UIColor.grayColor().CGColor
        notesTextView.layer.borderWidth = 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let mapViewController = segue.destinationViewController as? MapViewController else{
            return
        }
        
        mapViewController.loadDataFromYelp = false
    }
    
    func loadRating(forLocation: Location) -> Rating?{
        let ratingHelper = RatingHelper()
       return ratingHelper.getRatingForLocation(forLocation)
    }
    
    func displayRatingIfExisting(rating: Rating?){
        guard let r = rating where rating != nil else{
            setHiddenForRatingLabels(true)
            notesTextView.text = ""
            return
        }
        
        setHiddenForRatingLabels(false)
        noiseLevelStepper.value = Double(r.noiseLevel)
        noiseLevelLabel.text = getStepperLabelText(Double(r.noiseLevel))
        freeWifiSwitch.on = (r.freeWifi == 1)
        wifiStrengthStepper.value = Double(r.wifiStrength)
        wifiStrengthLabel.text = getStepperLabelText(Double(r.wifiStrength))
        seatingAvailabliityStepper.value = Double(r.seatingAvailability)
        seatingAvailabiltyLabel.text = getStepperLabelText(Double(r.seatingAvailability))
        workThereAgainSwitch.on = (r.workThereAgain == 1)
        notesTextView.text = r.notes
    }
    
    func setHiddenForRatingLabels(hidden: Bool){
        noiseLevelLabel.hidden = hidden
        wifiStrengthLabel.hidden = hidden
        seatingAvailabiltyLabel.hidden = hidden
    }
    
    func getStepperLabelText(level: Double) -> String{
        return "\(level) / 5"
    }
    
    func displayLocation(){
        if(location != nil){
            businessName.text = location?.businessName
            address.text = location?.address?.getAddressDisplayString(true)
            category.text = location?.category
            website.text = location?.website
        }
        else{
            hideControlsIfLocationIsNil()
        }
    }
    
    func hideControlsIfLocationIsNil(){
        setRatingControlsToDefaultState()
    }
    
    func setRatingControlsToDefaultState(){
        noiseLevelLabel.text = ""
        noiseLevelStepper.value = 1
        freeWifiSwitch.on = false
        wifiStrengthLabel.text = ""
        wifiStrengthStepper.value = 1
        seatingAvailabiltyLabel.text = ""
        seatingAvailabliityStepper.value = 1
        workThereAgainSwitch.on = false
        notesTextView.text = ""
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch(status){
        case .NotDetermined, .Restricted, .Denied:
            performSegueWithIdentifier("locationDisabledSegue", sender: nil)
            break
        default:
            break
        }
        
    }
    
    @IBAction func saveButton_Clicked(sender: UIBarButtonItem) {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        let id = NSUUID().UUIDString
        let date = NSDate()
        let _ = Rating(id: id, noise: noiseLevelStepper.value, freeWifi: freeWifiSwitch.on, wifiStrength: wifiStrengthStepper.value, seatingAvailabilityRating: seatingAvailabliityStepper.value, wouldWorkThereAgain: workThereAgainSwitch.on, notes: notesTextView.text, location: location!, created: date, context: context)
        
        CoreDataStackManager.sharedInstance().saveContext()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func noiseLevel_StepChanged(sender: UIStepper) {
        noiseLevelLabel.hidden = false
        noiseLevelLabel.text = getStepperLabelText(sender.value)
    }
    
    @IBAction func seatingAvailability_StepChanged(sender: UIStepper) {
        seatingAvailabiltyLabel.hidden = false
        seatingAvailabiltyLabel.text = getStepperLabelText(sender.value)
    }

    @IBAction func wifiStrength_StepChanged(sender: UIStepper) {

        wifiStrengthLabel.hidden = false
        wifiStrengthLabel.text = getStepperLabelText(sender.value)
    }
}