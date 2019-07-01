//
//  File.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/28/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import Contacts

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapConnection: MKMapView!
    
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 5000
    // set initial location in Honolulu
    var initialLocation = CLLocation(latitude: 0.0, longitude: 0.0)

    
    override func viewDidAppear(_ animated: Bool) {
        
        
     //     super.viewDidAppear(animated)
        locationManager.delegate = self
        mapConnection.delegate = self
      
       
        
        checkLocationAuthorizationStatus()
        locationManager.requestLocation()
   //     mapConnection.addAnnotations(interestLocations.shared.locationsGoogle)
        

  
    }
    
    override func viewDidLoad() {
        

        
        
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
            
         
            interestLocations.shared.lat =  locations.first!.coordinate.latitude as! Double
            interestLocations.shared.lon =  locations.first!.coordinate.longitude as! Double
            
            var counter = 0
            
            repeat {
            interestLocations.shared.locationSelectKeyword = interestLocations.shared.collection[counter].descripcion!
            let tofind =  interestLocations.shared.collection[counter].descripcion!
      
                ggoogleApi.requestData (palabraK: tofind) { (data, response, error, palabra) in
                ggoogleApi.readData(data: data!, palabra: tofind)
                self.mapConnection.reloadInputViews()
                    }
            counter = counter + 1
            } while counter < interestLocations.shared.collection.count
            
        mapConnection.addAnnotations(interestLocations.shared.locationsGoogle)
            
            
        }

}

}
    

extension MapViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? poinOfInterest else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.markerTintColor = annotation.markerTintColor
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! poinOfInterest
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }

   
}

