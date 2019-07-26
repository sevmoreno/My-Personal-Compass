//
//  detailsViewController.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 7/16/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GoogleMobileAds
import CoreData

class detailsViewController: UIViewController {
    
    @IBOutlet weak var palabra: UIView!
    @IBOutlet weak var palabraSeleccion: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var generalview: UIView!
    @IBOutlet weak var sellecionMapa: MKMapView!
    
    @IBOutlet weak var banner: GADBannerView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        
       generalview.layer.cornerRadius = 10

        self.banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = self
        banner.load(GADRequest())
        
        
       let  anotacion = interestLocations.shared.seleccionPOI as MKAnnotation
       sellecionMapa.addAnnotation(anotacion)
        
        let coordinateRegion = MKCoordinateRegion(center: anotacion.coordinate,
                                                  latitudinalMeters: 500, longitudinalMeters: 500)
        sellecionMapa.setRegion(coordinateRegion, animated: true)
        
        
        palabraSeleccion.text = interestLocations.shared.seleccionPOI.title?.uppercased()
        name.text = interestLocations.shared.seleccionPOI.subtitle
        
     //   sellecionMapa.centerCoordinate.latitude = interestLocations.shared.lat
     //   sellecionMapa.centerCoordinate.longitude = interestLocations.shared.lon
        
        
        ggoogleApi.requestDetails(locationID: interestLocations.shared.seleccionPOI.placeID) { (data, response, eror, palabra) in
            print(interestLocations.shared.seleccionPOI.placeID)
            if data == data {
                print("Error")
            }
            ggoogleApi.readDetails(data: data!, palabra: "")
            
            if interestLocations.shared.detailsLocation.result == nil {} else
            
            {
                
                if interestLocations.shared.detailsLocation.result?.formatted_address != nil
                {
                    DispatchQueue.main.async {
                        
                        self.adress.text = interestLocations.shared.detailsLocation.result?.formatted_address
                    }
                    
                }
                
                if interestLocations.shared.detailsLocation.result?.formatted_phone_number != nil
                {
                    DispatchQueue.main.async {
                        
                        self.phone.text = interestLocations.shared.detailsLocation.result?.formatted_phone_number
                    }
                    
                }
                
                
                if interestLocations.shared.detailsLocation.result?.website != nil
                {
                    DispatchQueue.main.async {
                        
                        self.website.text = interestLocations.shared.detailsLocation.result?.website
                    }
                    
                }
                
               if let referencia = interestLocations.shared.detailsLocation.result?.photos?.first?.photo_reference
               
               {
                ggoogleApi.getPhoto(photoID: referencia, complitionHandler: { (data,cadena) in
                    
                    DispatchQueue.main.async {
                        
                        self.imagen.image = UIImage(data:data!)
                    }
                    
                    self.imagen.reloadInputViews()
                    
                })
          
                }
                
                
            }
            
            
        }
        
    }
    
    
    @IBAction func callPhoneNumber(_ sender: Any) {
     
        let numero = (interestLocations.shared.detailsLocation.result?.formatted_phone_number)!
        guard let number = URL(string: "tel://" + numero) else { return }
        print("Numero de telefono")
        print(number.absoluteString)
        UIApplication.shared.open(number)

        
        
  
       
    }
    
    @IBAction func driveToLocation(_ sender: Any) {
        
        
         let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
         interestLocations.shared.seleccionPOI.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    
    
    @IBAction func visitWebsite(_ sender: Any) {
        
        if let url = URL(string: self.website.text!) {
            UIApplication.shared.open(url)
        }
        
    }
    
    @IBAction func saveInterest(_ sender: Any) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Iintrest",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(self.adress.text, forKeyPath: "iaddress")
        person.setValue(self.palabraSeleccion.text, forKeyPath: "ikeyword")
        person.setValue(self.name.text, forKeyPath: "iname")
        person.setValue(self.phone.text, forKeyPath: "iphonenumber")
        person.setValue(self.website.text, forKeyPath: "iurl")
        person.setValue(self.website.text, forKeyPath: "iurl")
        
        
        person.setValue(interestLocations.shared.seleccionPOI.coordinate.latitude, forKeyPath: "ilat")
        person.setValue(interestLocations.shared.seleccionPOI.coordinate.longitude, forKeyPath: "ilon")
    person.setValue(interestLocations.shared.detailsLocation.result?.photos?.first?.photo_reference, forKeyPath: "iurlphoto")
        
        // 4
        do {
            try managedContext.save()
            print("Interest Saved")
       //     interestLocations.shared.collection.append(person as! KeywordK)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
}
