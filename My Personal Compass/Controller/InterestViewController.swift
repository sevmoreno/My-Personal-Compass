//
//  ViewController.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/28/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class InterestViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
 
    
    @IBOutlet weak var bannerAd: GADBannerView!
    
    @IBOutlet weak var textInput: UITextField!
    
    @IBOutlet weak var tablaInterest: UITableView!
    
    override func viewDidLoad() {
       
        tablaInterest.delegate = self
        tablaInterest.dataSource = self
        textInput.delegate = self
        self.bannerAd.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerAd.rootViewController = self
        bannerAd.load(GADRequest())
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        

        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        

        
        let fetchrequest: NSFetchRequest<KeywordK> = KeywordK.fetchRequest()
        
        if let resultado = try? managedContext.fetch(fetchrequest)
        
        {
            print("Result in Core Data is \(resultado.isEmpty)")
            if resultado.isEmpty {

                
            var dummy = KeywordK(context:managedContext)
            dummy.descripcion = "You can add your interests in the list"
            dummy.estado = true

            save(descripcion: dummy.descripcion!, estado: dummy.estado)
            

            dummy.descripcion = "Check the items to look arround you"
            dummy.estado = false

            save(descripcion: dummy.descripcion!, estado: dummy.estado)
            
            dummy.descripcion = "And swipe your finger to delete it."
            dummy.estado = true
            save(descripcion: dummy.descripcion!, estado: dummy.estado)
            
            dummy.descripcion = "Cooking"
            dummy.estado = true

            save(descripcion: dummy.descripcion!, estado: dummy.estado)
            
            dummy.descripcion = "Books"
            dummy.estado = true

            save(descripcion: dummy.descripcion!, estado: dummy.estado)
                
            loadInterest()
                
                
                
            }
            else {
                
                loadInterest()
                
            }
        }
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y >= 0 {
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
            print("Se va a mostrar")
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if (self.view.frame.origin.y < 0) {
            view.frame.origin.y += getKeyboardHeight(notification: notification)
            view.reloadInputViews()
        }
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func addyourInterest(_ sender: Any) {
        
        if textInput.text == nil || textInput.text == "" {}
        
        else {
        if let haytexto=textInput.text
        {
            save(descripcion: haytexto, estado: true)
            loadInterest()
            textInput.text?.removeAll()
            self.view.endEditing(true)
            
            
        }
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

        
        if let listaInterest = try? managedContext.fetch(fetchrequest)
            
        {
            print("Lista de fotos \(listaInterest.count)")
            
            interestLocations.shared.collection = listaInterest
            
 
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
        
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        }
        
        else
        {
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
            
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

            
            let predicatephoto = NSPredicate(format: "descripcion == %@", interestLocations.shared.collection[indexPath.item].descripcion!)

            
            let subpredicates: [NSPredicate]

            
            subpredicates = [ predicatephoto]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
            
            fetchrequest.predicate = compoundPredicate
            
            let fotoToDelete = try? managedContext.fetch(fetchrequest)
            

            if fotoToDelete == nil
            {} else
            {
         
                let objetToUpdate = fotoToDelete?.first as! NSManagedObject
                
                if  cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    objetToUpdate.setValue(true, forKey: "estado")
                    interestLocations.shared.collection[indexPath.item].estado = true
                    
                } else
                {
                    cell.accessoryType = .none
                    objetToUpdate.setValue(false, forKey: "estado")
                    interestLocations.shared.collection[indexPath.item].estado = false
                }

                do {
                    try managedContext.save()
               
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
           
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            
            let fetchrequest: NSFetchRequest<KeywordK> = KeywordK.fetchRequest()

            
            let predicatephoto = NSPredicate(format: "descripcion == %@", interestLocations.shared.collection[indexPath.item].descripcion!)

            
            let subpredicates: [NSPredicate]

            
            subpredicates = [ predicatephoto]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
            
            fetchrequest.predicate = compoundPredicate
            
            let fotoToDelete = try? managedContext.fetch(fetchrequest)
            
            if fotoToDelete == nil
            {
                
            } else {
                
               if let interest = fotoToDelete!.first
               {
                managedContext.delete(interest)
                    
                    try? managedContext.save()
                    
                }
            }
            
            
            interestLocations.shared.collection.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }

    
}

extension InterestViewController: UITextFieldDelegate

{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print (textField.text)
        
        if textField.text == nil || textField.text == "" {
            self.view.endEditing(true)
            return false
        } else {
        
        if let haytexto=textField.text
        {
        save(descripcion: haytexto, estado: true)
        loadInterest()
        textField.text?.removeAll()
        self.view.endEditing(true)
            
            }}
            
            
        
            
        
        return true
        
    }
    
    
    
}
