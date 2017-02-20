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
//import AddressBook
import Contacts

class MapViewController : BaseViewController, MKMapViewDelegate{
    
    let locationHelper = LocationHelper()
    var locationArray: [Location] = []
    var loadDataFromYelp: Bool = true
    var longPressLat: Double? = nil
    var longPressLong: Double? = nil
    var userChangedRegion = false
    
    @IBOutlet weak var searchInAreaButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        if(locationAuthorized){
            setupMapView()
        }
        searchInAreaButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(locationAuthorized){
            setupMapView()
            getLocations()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let viewController = segue.destination as? RateLocationViewController else{
            return
        }
        
        viewController.location = sender as? Location
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if((status == .authorizedAlways) || (status == .authorizedWhenInUse)){
            getLocations()
            zoomMapToCurrentLocation()
        }
        else{
            performSegue(withIdentifier: "locationDisabledSegue", sender: nil)
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
    
    func updateMapViewToUserCurrentLocation(_ userLocation: CLLocationCoordinate2D) -> Void{
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpanMake(0.05, 0.05))
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func locationRefresh_Clicked(_ sender: UIBarButtonItem) {
        zoomMapToCurrentLocation()
        searchInAreaButton.isHidden = true
    }
    
    @IBAction func addLocation_Clicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newLocationSegue", sender: nil)
    }
    
    func getLocations() -> Void{
        let location = getUserCurrentLocation()
        locationArray.removeAll()
        if(location != nil){
            let lat = location!.latitude
            let long = location!.longitude
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
            
            if(hasNetworkConnection == false){
                loadDataFromYelp = false
                showAlert("Network Error", message: "You must have network access to use this app")
            }else{
                locationHelper.getLocations(lat, longitude: long, callYelp: loadDataFromYelp, completionHandler:processLocationSearchResults)
            }
        }
    }
    
    func createMKPointAnnotationFromLocation(_ location: Location) -> MKPointAnnotation{
        let coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        return annotation
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       //get the selected location from the array
        var selectedLocation: Location? = nil
        
        for(_, location) in locationArray.enumerated(){
            if(location.latitude == view.annotation!.coordinate.latitude){
                if(location.longitude == view.annotation!.coordinate.longitude){
                    selectedLocation = location
                    break
                }
            }
        }
        
        if(selectedLocation != nil){
            performSegue(withIdentifier: "rateLocationSegue", sender: selectedLocation)
        }
        mapView.deselectAnnotation(view.annotation!, animated: false)
    }
    
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) -> Void{
        /*
         code pulled from http://stackoverflow.com/questions/3959994/how-to-add-a-push-pin-to-a-mkmapviewios-when-touching/3960754#3960754
         */
        if(gestureRecognizer.state != .began){
            return;
        }
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        
        longPressLat = touchMapCoordinate.latitude
        longPressLong = touchMapCoordinate.longitude
        
        mapView.addAnnotation(annotation)
        
        let viewController = createNewLocationAlertView()
        present(viewController, animated: true, completion: nil)
    }
    
    func createNewLocationAlertView() -> UIAlertController{
        let viewController = UIAlertController(title: "Add Location", message: nil, preferredStyle: .alert)
        viewController.addTextField(configurationHandler: {
            (textField) in
            
            textField.placeholder = "Business Name"
        })
        
        viewController.addTextField(configurationHandler: {
            (textField) in
            
            textField.placeholder = "Website"
        })
        
        viewController.addTextField { (textField) in
            textField.placeholder = "Category"
        }
        
        viewController.addTextField { (textField) in
            textField.placeholder = "Phone Number"
        }
        viewController.addAction(UIAlertAction(title: "Save Location", style: .default, handler: {
            (alert) in
            let nameTextField = viewController.textFields![0] as UITextField
            let websiteTextField = viewController.textFields![1] as UITextField
            let category = viewController.textFields![2] as UITextField
            let phone = viewController.textFields![3] as UITextField
            self.createAndSaveLocation(nameTextField.text!, website: websiteTextField.text, category: category.text!, phone: phone.text)
        }))
        viewController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (_) in
            
            self.dismiss(animated: false, completion: {})
        }))
        
        return viewController
    }
    
    func createAndSaveLocation(_ name: String, website: String?, category: String, phone: String?) -> Void{
        let geoCoder = CLGeocoder()
        let clLocation = CLLocation(latitude: longPressLat!, longitude: longPressLong!)
        if(NetworkHelper.isConnectedToNetwork()){
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            geoCoder.reverseGeocodeLocation(clLocation, completionHandler: {
                (placemarks, error) in
                
                if(placemarks == nil || error != nil){
                    self.showAlert("Geocoding Error", message: error!.localizedDescription)
                    return
                }
                
                let placemark = placemarks?.first
                
                let dictionary = placemark!.addressDictionary!
                
                let street = (dictionary[CNPostalAddressStreetKey]! as AnyObject).description
                let city = (dictionary[CNPostalAddressCityKey]! as AnyObject).description
                let state = (dictionary[CNPostalAddressStateKey]! as AnyObject).description
                let zip = (dictionary[CNPostalAddressPostalCodeKey]! as AnyObject).description
                
                let address = Address(street: street!, city: city!, zip: zip!, state: state!)
                
                let id = UUID().uuidString
                let location = Location(id: id, lat: self.longPressLat!, long: self.longPressLong!, name: name, adr: address, url: website, category: category, phoneNumber: phone)
                
                DispatchQueue.main.async(execute: {
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.performSegue(withIdentifier: "rateLocationSegue", sender: location)
                })
            })
        }else{
            showAlert("Network Error", message: "You must have network access to use this app")
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if(userChangedRegion){
            searchInAreaButton.isHidden = !(Double(mapView.region.span.latitudeDelta) <= 0.065)
        }else{
            searchInAreaButton.isHidden = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let view = mapView.subviews[0]
        if let recongizers = view.gestureRecognizers{
            for recongizer in recongizers{
                if(recongizer.state == UIGestureRecognizerState.began || recongizer.state == UIGestureRecognizerState.ended){
                    userChangedRegion = true
                    break
                }
            }
        }
    }
    
    @IBAction func searchInAreaButton_Clicked(_ sender: UIButton) {
        searchInAreaButton.isHidden = true
        clearMapView()
        let boundingBox = getBoundingBox()
        loadDataFromYelp = true
        if(NetworkHelper.isConnectedToNetwork() == false){
            loadDataFromYelp = false
            showAlert("Network Error", message: "You must have network access to use this app")
        }
        
        locationHelper.getLocations(boundingBox, callYelp: loadDataFromYelp, completionHandler:processLocationSearchResults)
    }
    
    func clearMapView(){
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func getBoundingBox() -> BoundingBox{
        let nePoint = CGPoint(x: mapView.bounds.maxX, y: mapView.bounds.origin.y)
        let swPoint = CGPoint(x: mapView.bounds.minX, y: mapView.bounds.maxY)
        let neCoordinate = mapView.convert(nePoint, toCoordinateFrom: mapView)
        let swCoordinate = mapView.convert(swPoint, toCoordinateFrom: mapView)
        
        return BoundingBox(NorthEast: neCoordinate, SouthWest: swCoordinate)
    }
    
    func processLocationSearchResults(_ locations: [Location], error: NSError?){
        if(error != nil){
            if(error?.description == "Network Error"){
                self.showAlert("Network Error", message: "You must have network access to use this app")
            }
            print(error)
        }
        
        for(_, location) in locations.enumerated(){
            let annotation = self.createMKPointAnnotationFromLocation(location)
            self.mapView.addAnnotation(annotation)
            self.locationArray.append(location)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
        self.loadDataFromYelp = false

    }
}
