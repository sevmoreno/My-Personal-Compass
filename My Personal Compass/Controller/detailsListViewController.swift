//
//  detailsListViewController.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 7/19/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GoogleMobileAds
import CoreData


class detailsListViewController: UIViewController {

    @IBOutlet weak var lname: UILabel!
    @IBOutlet weak var laddress: UILabel!
    @IBOutlet weak var lphone: UILabel!
    @IBOutlet weak var lwebsite: UILabel!
    @IBOutlet weak var lmapa: MKMapView!
    @IBOutlet weak var limagen: UILabel!
    @IBOutlet weak var banner2: GADBannerView!
    @IBOutlet weak var imagen: UIImageView!
    
    @IBOutlet weak var generalview2: UIView!
    @IBOutlet weak var limagenlabel: UILabel!
    
    var objetoToDelete = Iintrest ()
    var indiceToDelete = 0
    
    override func viewDidLoad() {
        
        let indicelista = interestLocations.shared.iniceLista
        indiceToDelete = indicelista
        
        generalview2.layer.cornerRadius = 10
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.banner2.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner2.rootViewController = self
        banner2.load(GADRequest())
        

        
       
        
    
  //      lmapa.addAnnotation(anotacion)
        let ubicacion = CLLocationCoordinate2D (latitude: interestLocations.shared.colleccionLista[indicelista].ilat,longitude: interestLocations.shared.colleccionLista[indicelista].ilon)
        
      let coordinateRegion = MKCoordinateRegion(center: ubicacion,
                                         latitudinalMeters: 500, longitudinalMeters: 500)
       lmapa.setRegion(coordinateRegion, animated: true)
        
        let temporario = poinOfInterest(title: interestLocations.shared.colleccionLista[indicelista].ikeyword!, locationName:interestLocations.shared.colleccionLista[indicelista].iname!, keywordC: "", coordinate: ubicacion, placeAD:"")
     
        interestLocations.shared.seleccionPOI = temporario
        
        let  anotacion = temporario as MKAnnotation
        
        lmapa.addAnnotation(anotacion)

        objetoToDelete = interestLocations.shared.colleccionLista[indicelista]
        
        limagen.text = interestLocations.shared.colleccionLista[indicelista].ikeyword?.uppercased()
        lname.text = interestLocations.shared.colleccionLista[indicelista].iname

       
        laddress.text = interestLocations.shared.colleccionLista[indicelista].iaddress
        lphone.text = interestLocations.shared.colleccionLista[indicelista].iphonenumber
        lwebsite.text = interestLocations.shared.colleccionLista[indicelista].iurl
        
        if let referencia = interestLocations.shared.colleccionLista[indicelista].iurlphoto {
        ggoogleApi.getPhoto(photoID: referencia, complitionHandler: { (data,cadena) in
            
            DispatchQueue.main.async {
                
                self.imagen.image = UIImage(data:data!)
                  }
            
            self.imagen.reloadInputViews()
            
        })
        }
        
        
    }
    

    

    @IBAction func callPhoneNumber(_ sender: Any) {
        
        
        let numero = (lphone.text)!
        guard let number = URL(string: "tel://" + numero) else { return }
        print("Numero de telefono")
        print(number.absoluteString)
        UIApplication.shared.open(number)
        
        
        
    }
    @IBAction func goLocation(_ sender: Any) {
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        interestLocations.shared.seleccionPOI.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    @IBAction func visitWebsite(_ sender: Any) {
        
        
        if let url = URL(string: self.lwebsite.text!) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func deletItem(_ sender: Any) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        managedContext.delete(objetoToDelete)
        interestLocations.shared.colleccionLista.remove(at: indiceToDelete)
        print("Interest Deleted")
        _ = navigationController?.popViewController(animated: false)
        
        
        
        
    }
    
}

