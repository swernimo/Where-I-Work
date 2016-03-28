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
    var loadDataFromYelp: Bool = true
    
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
                showNetWorkErrorAlert()
            }
            
            locationHelper.getLocations(lat, longitude: long, callYelp: loadDataFromYelp){
                (locations, error) in
                
                if(error != nil){
                    if(error?.description == "Network Error"){
                        self.showNetWorkErrorAlert()
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
    
    func showNetWorkErrorAlert(){
        let alertview = UIAlertController(title: "Network Error", message: "You must have network access to use this app", preferredStyle: .Alert)
        self.showViewController(alertview, sender: nil)
    }
    
    func createMKPointAnnotationFromLocation(location: Location) -> MKPointAnnotation{
        let coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
//        annotation.title = location.businessName
//        annotation.subtitle = location.category
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
            //print("selected location id is: \(selectedLocation!.id)")
            performSegueWithIdentifier("rateLocationSegue", sender: selectedLocation)
        }
        mapView.deselectAnnotation(view.annotation!, animated: false)
    }
}