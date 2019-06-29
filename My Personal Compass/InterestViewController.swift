//
//  ViewController.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/28/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit

class InterestViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
 
    

    @IBOutlet weak var tablaInterest: UITableView!
    
    override func viewDidLoad() {
       
        tablaInterest.delegate = self
        tablaInterest.dataSource = self
        
        
        // ---- HOW TO INTIAL AN OBJET WITH COREDATE PAPU
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //  interestLocations.shared.lat = 12.0
        let prueba = KeywordK(context:managedContext)
        prueba.descripcion = "Hey"
        prueba.estado = false
        
        interestLocations.shared.collection.append(prueba)
        
        
        //----------------------------------------
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interestLocations.shared.collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
   
   if interestLocations.shared.collection.count > 0
        
   {
   
    if let label = cell.viewWithTag(700) as? UILabel
    
        {
            label.text = interestLocations.shared.collection[indexPath.item].descripcion
            
        }
        
        if interestLocations.shared.collection[indexPath.item].estado == true
        {
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
    }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath)
            
        {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else
            {
                cell.accessoryType = .none
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
}


/*
 
 locationManager.requestLocation()
 locationManager.desiredAccuracy = kCLLocationAccuracyBest
 locationManager.distanceFilter = kCLDistanceFilterNone
 locationManager.startUpdatingLocation()
 
 mapLink.showsUserLocation = true
 
 */

