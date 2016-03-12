//
//  NewLocationViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/7/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import UIKit

class NewLocationViewController: UIViewController{
    
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var pinColor: UISegmentedControl!
    
    override func viewDidLoad() {
        loadDefaults()
    }
    
    func loadDefaults() -> Void{
        
    }
    
    
    @IBAction func cancelButton_Clicked(sender: UIBarButtonItem) {
        print("cancel add new location")
        loadDefaults()
        performSegueWithIdentifier("cancelAddSegue", sender: nil)
    }
    
    @IBAction func saveButton_Clicked(sender: UIBarButtonItem) {
        print("save new location")
        //create new location
        //save it to core data
        //navigate to the rating page
    }
}