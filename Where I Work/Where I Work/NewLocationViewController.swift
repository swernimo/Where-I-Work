//
//  NewLocationViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/7/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class NewLocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate{
    
    let categories: [String] = ["Select A Category", "Coffee", "Library"]
    
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var category: UITextField!
    
    override func viewDidLoad() {
        loadDefaults()
    }
    
    func loadDefaults() -> Void{
        businessName.text = nil
        streetAddress.text = nil
        city.text = nil
        state.text = nil
        zipCode.text = nil
        website.text = nil
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
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
    
    @IBAction func cancelButton_Clicked(sender: UIBarButtonItem) {
        loadDefaults()
        performSegueWithIdentifier("cancelAddSegue", sender: nil)
    }
    
    @IBAction func saveButton_Clicked(sender: UIBarButtonItem) {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
       let id = NSUUID().UUIDString
        let geoCoder = CLGeocoder()
        let address = Address(street: streetAddress.text!, city: city.text!, zip: zipCode.text!, state: state.text!, context: context)
        if(NetworkHelper.isConnectedToNetwork()){
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            geoCoder.geocodeAddressString(address.getAddressDisplayString(false)){
                (result, error) in
                
                if(result != nil && error == nil){
                    let placeMark = result?.first
                    let latitude = placeMark?.location?.coordinate.latitude
                    let longitude = placeMark?.location?.coordinate.longitude
                    
                    let location = Location(id: id, lat: latitude!, long: longitude!, name: self.businessName.text!, adr: address, url: self.website.text, category: self.category.text!, context: context)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        CoreDataStackManager.sharedInstance().saveContext()
                        self.performSegueWithIdentifier("rateLocationSegue", sender: location)
                    })
                }
                else{
                    self.showAlert("Geocoding Error", message: error!.description)
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }else{
            showAlert("Network Error", message: "You must have network access to use this app")
        }
    }
    
    func showAlert(title: String, message: String){
        let alertview = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertview.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
        presentViewController(alertview, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "rateLocationSegue"){
            let viewController = segue.destinationViewController as! RateLocationViewController
            
            viewController.location = sender as? Location
            
        }
    }
}