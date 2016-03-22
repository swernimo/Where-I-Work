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

class MapViewController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    var locationManager: CLLocationManager!
    let locationHelper = LocationHelper()
    var locationArray: [Location] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
       setupLocationManager()
        switch(CLLocationManager.authorizationStatus()){
        case .NotDetermined, .Restricted, .Denied:
         performSegueWithIdentifier("locationNotAuthorizedSegue", sender: nil)
            break
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            setupMapView()
            getLocations()
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let viewController = segue.destinationViewController as? NewLocationViewController else{
            return
        }
        
        viewController.longitude = (locationManager.location?.coordinate)!.longitude
        viewController.latitude = (locationManager.location?.coordinate)!.latitude
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
        }
        else{
            performSegueWithIdentifier("locationNotAuthorizedSegue", sender: nil)
        }
    }

    func setupMapView(){
        mapView.delegate = self
        updateMapViewToUserCurrentLocation(getUserCurrentLocation())
    }
    
    func getUserCurrentLocation() -> CLLocationCoordinate2D{
        return (locationManager.location?.coordinate)!
    }
    
    func updateMapViewToUserCurrentLocation(userLocation: CLLocationCoordinate2D) -> Void{
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpanMake(0.01, 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func locationRefresh_Clicked(sender: UIBarButtonItem) {
        updateMapViewToUserCurrentLocation(getUserCurrentLocation())
    }
    
    @IBAction func addLocation_Clicked(sender: UIBarButtonItem) {
        performSegueWithIdentifier("newLocationSegue", sender: nil)
    }
    
    func getLocations() -> Void{
        let location = getUserCurrentLocation()
        let lat = location.latitude
        let long = location.longitude
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        locationHelper.getLocations(lat, longitude: long){
            (locations, error) in
            
            if(error != nil){
                if(error?.description == "Network Error"){
                    let alertview = UIAlertController(title: "Network Error", message: "You must have network access to use this app", preferredStyle: .Alert)
                    self.showViewController(alertview, sender: nil)
                }
                print(error)
            }
            
            for(_, location) in locations.enumerate(){
                let annotation = self.createMKPointAnnotationFromLocation(location)
                self.mapView.addAnnotation(annotation)
                self.locationArray.append(location)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        }
    }
    
    func createMKPointAnnotationFromLocation(location: Location) -> MKPointAnnotation{
        let coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.businessName
        annotation.subtitle = location.category
        return annotation
    }
    
    //code taken from pin sample app
//    
//    // Here we create a view with a "right callout accessory view". You might choose to look into other
//    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
//    // method in TableViewDataSource.
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        let reuseId = "pin"
//        
//        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
//        
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView!.canShowCallout = true
//            pinView!.pinTintColor = UIColor.redColor();
//            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
//        }
//        else {
//            pinView!.annotation = annotation
//        }
//        
//        return pinView
//    }
//    
//    
//    // This delegate method is implemented to respond to taps. It opens the system browser
//    // to the URL specified in the annotationViews subtitle property.
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            let app = UIApplication.sharedApplication()
//            if let toOpen = view.annotation?.subtitle! {
//                app.openURL(NSURL(string: toOpen)!)
//            }
//        }
//    }
    
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
}