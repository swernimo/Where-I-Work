//
//  MapViewController.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/7/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import AddressBook

class MapViewController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    var locationManager: CLLocationManager!
    let locationHelper = LocationHelper()
    var locationArray: [Location] = []
    var loadDataFromYelp: Bool = true
    var longPressLat: Double? = nil
    var longPressLong: Double? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
       setupLocationManager()
        switch(CLLocationManager.authorizationStatus()){
        case .NotDetermined, .Restricted, .Denied:
         performSegueWithIdentifier("locationDisabledSegue", sender: nil)
            break
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            setupMapView()
            break
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .AuthorizedWhenInUse){
            setupMapView()
            getLocations()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let viewController = segue.destinationViewController as? RateLocationViewController else{
            return
        }
        
        viewController.location = sender as? Location
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
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if((status == .AuthorizedAlways) || (status == .AuthorizedWhenInUse)){
            getLocations()
            zoomMapToCurrentLocation()
        }
        else{
            performSegueWithIdentifier("locationDisabledSegue", sender: nil)
        }
    }
    
    func zoomMapToCurrentLocation(){
        let currentLocation = getUserCurrentLocation()
        if(currentLocation != nil){
            updateMapViewToUserCurrentLocation(currentLocation!)
        }
    }
    
    func setupMapView(){
        mapView.delegate = self
        mapView.removeAnnotations(mapView.annotations)
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        
        longPressRecogniser.minimumPressDuration = 1.5
        
        mapView.addGestureRecognizer(longPressRecogniser)
        zoomMapToCurrentLocation()
    }
    
    func getUserCurrentLocation() -> CLLocationCoordinate2D?{
        return (locationManager.location?.coordinate)
    }
    
    func updateMapViewToUserCurrentLocation(userLocation: CLLocationCoordinate2D) -> Void{
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpanMake(0.05, 0.05))
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func locationRefresh_Clicked(sender: UIBarButtonItem) {
        zoomMapToCurrentLocation()
    }
    
    @IBAction func addLocation_Clicked(sender: UIBarButtonItem) {
        performSegueWithIdentifier("newLocationSegue", sender: nil)
    }
    
    func getLocations() -> Void{
        let location = getUserCurrentLocation()
        locationArray.removeAll()
        if(location != nil){
            let lat = location!.latitude
            let long = location!.longitude
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
            
            if(NetworkHelper.isConnectedToNetwork() == false){
                loadDataFromYelp = false
                showAlert("Network Error", message: "You must have network access to use this app")
            }
            
            locationHelper.getLocations(lat, longitude: long, callYelp: loadDataFromYelp){
                (locations, error) in
                
                if(error != nil){
                    if(error?.description == "Network Error"){
                        self.showAlert("Network Error", message: "You must have network access to use this app")
                    }
                    print(error)
                }
                
                for(_, location) in locations.enumerate(){
                    let annotation = self.createMKPointAnnotationFromLocation(location)
                    self.mapView.addAnnotation(annotation)
                    self.locationArray.append(location)
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
                self.loadDataFromYelp = false
            }
        }
    }
    
    func showAlert(title: String, message: String){
        let alertview = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertview.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
        presentViewController(alertview, animated: true, completion: nil)
    }
    
    func createMKPointAnnotationFromLocation(location: Location) -> MKPointAnnotation{
        let coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        return annotation
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
       //get the selected location from the array
        var selectedLocation: Location? = nil
        
        for(_, location) in locationArray.enumerate(){
            if(location.latitude == view.annotation!.coordinate.latitude){
                if(location.longitude == view.annotation!.coordinate.longitude){
                    selectedLocation = location
                    break
                }
            }
        }
        
        if(selectedLocation != nil){
            performSegueWithIdentifier("rateLocationSegue", sender: selectedLocation)
        }
        mapView.deselectAnnotation(view.annotation!, animated: false)
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) -> Void{
        /*
         code pulled from http://stackoverflow.com/questions/3959994/how-to-add-a-push-pin-to-a-mkmapviewios-when-touching/3960754#3960754
         */
        if(gestureRecognizer.state != .Began){
            return;
        }
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        
        longPressLat = touchMapCoordinate.latitude
        longPressLong = touchMapCoordinate.longitude
        
        mapView.addAnnotation(annotation)
        
        let viewController = createNewLocationAlertView()
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func createNewLocationAlertView() -> UIAlertController{
        let viewController = UIAlertController(title: "Add Location", message: nil, preferredStyle: .Alert)
        viewController.addTextFieldWithConfigurationHandler({
            (textField) in
            
            textField.placeholder = "Business Name"
        })
        
        viewController.addTextFieldWithConfigurationHandler({
            (textField) in
            
            textField.placeholder = "Website"
        })
        
        viewController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Category"
        }
        viewController.addAction(UIAlertAction(title: "Save Location", style: .Default, handler: {
            (alert) in
            let nameTextField = viewController.textFields![0] as UITextField
            let websiteTextField = viewController.textFields![1] as UITextField
            let category = viewController.textFields![2] as UITextField
            self.createAndSaveLocation(nameTextField.text!, website: websiteTextField.text, category: category.text!)
        }))
        
        return viewController
    }
    
    func createAndSaveLocation(name: String, website: String?, category: String) -> Void{
        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        
        let geoCoder = CLGeocoder()
        let clLocation = CLLocation(latitude: longPressLat!, longitude: longPressLong!)
        if(NetworkHelper.isConnectedToNetwork()){
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            geoCoder.reverseGeocodeLocation(clLocation, completionHandler: {
                (placemarks, error) in
                
                if(placemarks == nil || error != nil){
                    self.showAlert("Geocoding Error", message: error!.description)
                    return
                }
                
                let placemark = placemarks?.first
                
                let dictionary = placemark!.addressDictionary!
                
                let street = dictionary[kABPersonAddressStreetKey]!.description
                let city = dictionary[kABPersonAddressCityKey]!.description
                let state = dictionary[kABPersonAddressStateKey]!.description
                let zip = dictionary[kABPersonAddressZIPKey]!.description
                
                let address = Address(street: street, city: city, zip: zip, state: state, context: context)
                
                let id = NSUUID().UUIDString
                let location = Location(id: id, lat: self.longPressLat!, long: self.longPressLong!, name: name, adr: address, url: website, category: category, context: context)
                
                CoreDataStackManager.sharedInstance().saveContext()
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.performSegueWithIdentifier("rateLocationSegue", sender: location)
                })
            })
        }else{
            showAlert("Network Error", message: "You must have network access to use this app")
        }
    }
}