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
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
   if let label = cell.viewWithTag(700) as? UILabel
        {
            label.text = "Wewes"
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath)
            
        {
            print ("Seleccion" )
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

