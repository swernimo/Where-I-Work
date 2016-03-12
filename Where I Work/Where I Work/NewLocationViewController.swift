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

class NewLocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate{
    
    let categories: [String] = ["Select A Category", "Coffee", "Library"]
    
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var pinColor: UISegmentedControl!
    
    override func viewDidLoad() {
        setupCategoryPickerView()
        loadDefaults()
    }
    
    func loadDefaults() -> Void{
        businessName.text = nil
        streetAddress.text = nil
        city.text = nil
        state.text = nil
        zipCode.text = nil
        website.text = nil
        pinColor.selectedSegmentIndex = 3
        categoryPicker.selectRow(0, inComponent: 0, animated: false)
    }
    
    func setupCategoryPickerView(){
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.showsSelectionIndicator = true    }
    
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
            performSegueWithIdentifier("locationNotAuthorizedSegue", sender: nil)
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
        //create new location
        //save it to core data
        //navigate to the rating page
    }
}