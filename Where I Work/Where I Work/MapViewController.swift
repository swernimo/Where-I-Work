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
//        let segueName = segue.identifier;
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
        print("location authorization status changed")
        if((status == .AuthorizedAlways) || (status == .AuthorizedWhenInUse)){
            print("location services are now authorized.")
            getLocations()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //code taken from http://stackoverflow.com/questions/25449469/swift-show-current-location-and-update-location-in-a-mkmapview
//        let location = locations.last! as CLLocation
//        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        mapView.setRegion(region, animated: true)
//            region.span.latitudeDelta.
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
    
    func getLocations() -> Void{
        let location = getUserCurrentLocation()
        let lat = location.latitude
        let long = location.longitude
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        locationHelper.getLocations(lat, longitude: long){
            (locations, error) in
            
            if(error != nil){
                print(error)
            }
            
            for(_, location) in locations.enumerate(){
                let annotation = self.createMKPointAnnotationFromLocation(location)
                self.mapView.addAnnotation(annotation)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        }
    }
    
    func createMKPointAnnotationFromLocation(location: Location) -> MKPointAnnotation{
        let location = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        return annotation
    }
}