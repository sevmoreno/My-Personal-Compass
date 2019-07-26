//
//  ListaViewControlller.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 7/18/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import GoogleMobileAds

class ListaViewControlller: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var listaInteres: UITableView!
    
    @IBOutlet weak var bannerPubli: GADBannerView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Hay \(interestLocations.shared.colleccionLista.count) Elementos")
        return interestLocations.shared.colleccionLista.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIDA", for: indexPath)
        
        if interestLocations.shared.colleccionLista.count > 0
            
        {
            
            
            
            if let label = cell.viewWithTag(800) as? UILabel
                
            {
                label.text = interestLocations.shared.colleccionLista[indexPath.item].ikeyword
                
            }
            
            if let label = cell.viewWithTag(801) as? UILabel
                
            {
                label.text = interestLocations.shared.colleccionLista[indexPath.item].iname
                
            }
          
        }
        
        
        
        
        return cell
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.navigationController?.isNavigationBarHidden = true
        listaInteres.delegate.self = self
        listaInteres.dataSource.self = self
        loadListInterest()
        
        self.bannerPubli.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerPubli.rootViewController = self
        bannerPubli.load(GADRequest())
        
    }
    
    
    func loadListInterest ()
        
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchrequest: NSFetchRequest<Iintrest> = Iintrest.fetchRequest()
        
        
        if let listaInterestresult = try? managedContext.fetch(fetchrequest)
            
        {
            print("Lista de fotos \(listaInterestresult.count)")
            
            interestLocations.shared.colleccionLista = listaInterestresult
            
            
        }
        
        DispatchQueue.main.async {
            
            self.listaInteres.reloadData()
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailsList", sender: nil)
        interestLocations.shared.iniceLista = indexPath.row
        
       
        
       
        print("Seleccion de la tabla ")
        print(indexPath.row)
        
    }
  
    /*
       func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegue(withIdentifier: "detailsList", sender: nil)
        print("Seleccion de la tabla ")
        print(indexPath.row)
    }
   */
    
    
}
