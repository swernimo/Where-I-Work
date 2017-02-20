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

class NewLocationViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
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
        phone.text = nil
        category.text = nil
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch(status){
//        case .notDetermined, .restricted, .denied:
//            performSegue(withIdentifier: "locationDisabledSegue", sender: nil)
//            break
//        default:
//            break
//        }
//    }
    
    @IBAction func cancelButton_Clicked(_ sender: UIBarButtonItem) {
        loadDefaults()
        performSegue(withIdentifier: "cancelAddSegue", sender: nil)
    }
    
    @IBAction func saveButton_Clicked(_ sender: UIBarButtonItem) {
       let id = UUID().uuidString
        let geoCoder = CLGeocoder()
        let address = Address(street: streetAddress.text!, city: city.text!, zip: zipCode.text!, state: state.text!)
        if(NetworkHelper.isConnectedToNetwork()){
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            geoCoder.geocodeAddressString(address.getAddressDisplayString(false)){
                (result, error) in
                
                if(result != nil && error == nil){
                    let placeMark = result?.first
                    let latitude = placeMark?.location?.coordinate.latitude
                    let longitude = placeMark?.location?.coordinate.longitude
                    var websiteAddress = self.website.text
                    
                    print("geocode Latitude: \(latitude)")
                    print("geocode longitude: \(longitude)")
                    let googleClient = GoogleClient()
                    googleClient.searchForPlace(latitude!, longitude: longitude!){
                       (place, error) in
//                        guard let _ = error where error != nil else{
//                            print("Google Places Error")
//                            print(error?.description)
//                            return
//                        }

                        if(error != nil){
                            
                        }
                        
                        if(place != nil){
                            print("Google Latitude: \(place?.coordinate.latitude)")
                            print("Google Longitude: \(place?.coordinate.longitude)")
                            if(websiteAddress == nil && place?.website != nil){
                                websiteAddress = place?.website?.absoluteString
                            }
                            //update the location information (phone number, website, name, etc) with the information from google
                        }
                    }//, completionHandler: <#T##(place: GMSPlace?, error: NSError?) -> Void#>)
                    
                    let location = Location(id: id, lat: latitude!, long: longitude!, name: self.businessName.text!, adr: address, url: websiteAddress, category: self.category.text!, phoneNumber: self.phone.text)
                    
                    DispatchQueue.main.async(execute: {
                        
// CoreDataStackManager.sharedInstance().saveContext()
                        self.performSegue(withIdentifier: "rateLocationSegue", sender: location)
                    })
                }
                else{
                    self.showAlert("Geocoding Error", message: error!.localizedDescription)
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }else{
            showAlert("Network Error", message: "You must have network access to use this app")
        }
    }
    
//    func showAlert(_ title: String, message: String){
//        let alertview = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertview.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//        present(alertview, animated: true, completion: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "rateLocationSegue"){
            let viewController = segue.destination as! RateLocationViewController
            
            viewController.location = sender as? Location
            
        }
    }
}
