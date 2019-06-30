//
//  ViewController.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/28/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit
import CoreData

class InterestViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
 
    

    @IBOutlet weak var textInput: UITextField!
    
    @IBOutlet weak var tablaInterest: UITableView!
    
    override func viewDidLoad() {
       
        tablaInterest.delegate = self
        tablaInterest.dataSource = self
        textInput.delegate = self
        
        
        
        
        // ---- HOW TO INTIAL AN OBJET WITH COREDATE PAPU
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //  interestLocations.shared.lat = 12.0
        //      let prueba = KeywordK(context:managedContext)
            //    prueba.descripcion = "Hey"
        //        prueba.estado = false
 
       //      interestLocations.shared.collection.append(prueba)

        
        //----------------------------------------

        // CHECK IF CONTENT IN CORE DATA
        // -------------------------
        
        
        let fetchrequest: NSFetchRequest<KeywordK> = KeywordK.fetchRequest()
        
        if let resultado = try? managedContext.fetch(fetchrequest)
        
        {
            print("Result in Core Data is \(resultado.isEmpty)")
            if resultado.isEmpty {
           // if is empty creat dummy data
                
                
            }
            else {
                
                loadInterest()
                
            }
        }
        
        
    }
    
    
    @IBAction func addyourInterest(_ sender: Any) {
        
        if let haytexto=textInput.text
        {
            save(descripcion: haytexto, estado: true)
            loadInterest()
            textInput.text?.removeAll()
            
            
        }
        
    }
    
    
    func loadInterest ()
        
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchrequest: NSFetchRequest<KeywordK> = KeywordK.fetchRequest()
        //   let predicate = NSPredicate (format: "pin == %@" ,photoInfo.shared.pinSelected )
        //   fetchrequest.predicate = predicate
        
        if let listaInterest = try? managedContext.fetch(fetchrequest)
            
        {
            print("Lista de fotos \(listaInterest.count)")
            
            interestLocations.shared.collection = listaInterest
            
            /*
             var  c = 0
             repeat {
             let temp = toSaveDisplay(Imagen: listaPhotos[c].imagen, ImagenURL: listaPhotos[c].imageURL, photoID: listaPhotos[c].photoID, userID: listaPhotos[c].userID)
             photoInfo.shared.collectionImage.append(temp)
             c = c + 1
             } while c < listaInterest.count
             
             */
        }
        
        DispatchQueue.main.async {
            
            self.tablaInterest.reloadData()
        }
        
        
    }
    
    func save(descripcion: String, estado: Bool) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "KeywordK",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(descripcion, forKeyPath: "descripcion")
        person.setValue(estado, forKeyPath: "estado")
        
        // 4
        do {
            try managedContext.save()
            interestLocations.shared.collection.append(person as! KeywordK)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            let fetchrequest: NSFetchRequest<KeywordK> = KeywordK.fetchRequest()
            let predicate = NSPredicate (format: "descripcion == %@" ,interestLocations.shared.collection[indexPath.item].descripcion! )
            fetchrequest.predicate = predicate
            
            if let interestToChange = try? managedContext.fetch(fetchrequest)
                
            {
                
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    interestToChange.first?.estado = true
                    interestLocations.shared.collection[indexPath.item].estado = true
                    
                } else
                {
                    cell.accessoryType = .none
                    interestToChange.first?.estado = false
                    interestLocations.shared.collection[indexPath.item].estado = false
                }
               
                let entity =
                    NSEntityDescription.entity(forEntityName: "KeywordK",
                                               in: managedContext)!
                
                let person = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
                
                // 3
                person.setValue(interestToChange.first?.estado, forKeyPath: "estado")

                
                // 4
                do {
                    try managedContext.save()
               
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
           
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
}

extension InterestViewController: UITextFieldDelegate

{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print (textField.text)
        
        if let haytexto=textField.text
        {
        save(descripcion: haytexto, estado: true)
        loadInterest()
        textField.text?.removeAll()
            
            
        }
        
        return true
        
    }
    
    
    
}
/*
 
 locationManager.requestLocation()
 locationManager.desiredAccuracy = kCLLocationAccuracyBest
 locationManager.distanceFilter = kCLDistanceFilterNone
 locationManager.startUpdatingLocation()
 
 mapLink.showsUserLocation = true
 
 */

