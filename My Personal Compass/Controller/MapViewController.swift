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
import Reachability
import GoogleMobileAds

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapConnection: MKMapView!
    
    @IBOutlet weak var bannerAd2: GADBannerView!
    
    @IBOutlet weak var activityDownload: UIActivityIndicatorView!
    
    let reachability = Reachability()!
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 5000
    var initialLocation = CLLocation(latitude: 0.0, longitude: 0.0)

    
    
    
    override func viewDidAppear(_ animated: Bool) {
        

        locationManager.delegate = self
        mapConnection.delegate = self
        

        
        if interestLocations.shared.collection.isEmpty {
            
            showEmpty()
        }
        
        else {
            
        checkLocationAuthorizationStatus()

            
        locationManager.requestLocation()

        }
        

  
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        self.bannerAd2.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerAd2.rootViewController = self
        bannerAd2.load(GADRequest())
   
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
   
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.showAlert()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        
        
        
   
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            showAlert()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Network connection fails", message: "Check your connection and try again",         preferredStyle: UIAlertController.Style.alert)
        
      alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { _ in
        self.locationManager.requestLocation()
      }))
  
        self.present(alert, animated: true, completion: nil)
    }
    
    func showEmpty() {
        let alert = UIAlertController(title: "We need to know your interests", message: "Please add interests on your list",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            

            
        }))
        
        self.present(alert, animated: true, completion: nil)
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
            
            activityDownload.isHidden = false
            activityDownload.startAnimating()
            
            DispatchQueue.main.async {
                
                self.mapConnection.removeAnnotations(interestLocations.shared.googleresults as! [MKAnnotation])
            }
            
            
            initialLocation = locations.first!
            print("location:: \(locations.first?.coordinate.latitude)")
            centerMapOnLocation(location: initialLocation)
            
         
            interestLocations.shared.lat =  locations.first!.coordinate.latitude as! Double
            interestLocations.shared.lon =  locations.first!.coordinate.longitude as! Double
            
            var counter = 0
            
            repeat {
            if interestLocations.shared.collection[counter].descripcion != nil
            {
            interestLocations.shared.locationSelectKeyword = interestLocations.shared.collection[counter].descripcion!
                }
                let tofind =  interestLocations.shared.collection[counter].descripcion!
                
                if interestLocations.shared.collection[counter].estado == true {
                ggoogleApi.requestData (palabraK: tofind) { (data, response, error, palabra) in
                    if data == data {} else {
                        
                        DispatchQueue.main.async {
                            
                            self.showAlert()
                        }
                        
                        return
                    }
                ggoogleApi.readData(data: data!, palabra: tofind)
                self.mapConnection.reloadInputViews()
                    }
                }
            counter = counter + 1
            } while counter < interestLocations.shared.collection.count
            
            activityDownload.isHidden = true
            activityDownload.stopAnimating()
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
    
    
    // TO DO INSERT VIEW 
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! poinOfInterest
       
        interestLocations.shared.seleccionPOI = location
        
        performSegue(withIdentifier: "detailsIdent", sender: nil)
        
        //  location.placeID
        
        
        
        // CODE FOR LUCH MAP ---------------------------------------------------------
       //  let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
       //  location.mapItem().openInMaps(launchOptions: launchOptions)
    }

   
}

