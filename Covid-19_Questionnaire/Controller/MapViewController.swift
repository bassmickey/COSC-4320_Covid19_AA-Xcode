//
//  MapViewController.swift
//  Covid-19_Questionnaire
//
//  Created by Miguel Barajas on 11/23/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    /// dismisses the screen
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        // stop requesting user's location
        locationManager.stopUpdatingLocation()
        
        // dismisses the screen and goes back to the previous one
        self.dismiss(animated: true, completion: nil)
    }
    
    /// find nearby hospitals
    @objc private func findNearbyHospitals() {
        /* remove previous annotations should the user take the test
         * multiple times from different locations */
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        // search nearby hospitals within the user's region
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "hospital"
        request.region = self.mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            // handles error
            guard let response = response, error == nil else {
                return
            }
            
            // populates an array of placemarks
            for mapItem in response.mapItems {
                self.addPlacemarkToMap(placemark: mapItem.placemark)
            }
        }
    }
    
    /// add an annotation to a specific coordinate
    private func addPlacemarkToMap(placemark :CLPlacemark) {
        let coordinate = placemark.location?.coordinate
        let annotation = MKPointAnnotation()
        
        annotation.title = placemark.name
        annotation.coordinate = coordinate!
        self.mapView.addAnnotation(annotation)
    }
    
    /// get directions upon selecting a hospital
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let coordinate = annotation.coordinate
            let destinationPlacemark = MKPlacemark(coordinate: coordinate)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            // takes the user to apple maps
            MKMapItem.openMaps(with: [destinationMapItem], launchOptions: nil)
        }
    }
    
    /// zoom in to the user's location and constraint the points of interest to a region
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // center the screen around the user's coordinates
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        // plays an animation while zooming into the user's location
        mapView.setRegion(region, animated: true)
        
        // wait until you're zoomed into the user's location before populating the map with annotations
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(findNearbyHospitals), userInfo: nil, repeats: false)
    }
}
