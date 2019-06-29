//
//  File.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/28/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapConnection: MKMapView!
    
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 10000
    // set initial location in Honolulu
    var initialLocation = CLLocation(latitude: 0.0, longitude: 0.0)

    
    override func viewDidAppear(_ animated: Bool) {
        
        
          super.viewDidAppear(animated)
        locationManager.delegate = self
      
        checkLocationAuthorizationStatus()
        locationManager.requestLocation()
        
      //  interestLocations.shared.lat = 12.0
        
        
     //   locationInfo = locationManager.location?.coordinate.latitude
     //   print(locationInfo.)

        
    }
    
    @IBAction func discoverItems(_ sender: Any) {
        
        locationManager.requestLocation()
        
        
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapConnection.setRegion(coordinateRegion, animated: true)
    }
    
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapConnection.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            initialLocation = locations.first!
            print("location:: \(locations.first?.coordinate.latitude)")
            centerMapOnLocation(location: initialLocation)
        }
        
    }
    
}
