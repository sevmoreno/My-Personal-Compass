//
//  googleApi.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/29/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class ggoogleApi {
    
    static let base: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?&key=AIzaSyAjt6INZiPH-K3DyI-WvVZRiBj-cCWPobQ"
    
    
    // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=YOUR_API_KEY
    
    static var lat: String = "34.0194"
    static var lon: String = "-118.411"
    static let city = "&accuracy=11"
    static var radius = "&radius=1500"
    static var keyword = "beer"

    
    
    
    class func requestData (complitionHandler: @escaping (Data?,URLResponse?,Error?) -> Void) {
        
        lat = String (interestLocations.shared.lat)
        lon = String (interestLocations.shared.lon)
        
 //       if let a = interestLocations.shared.locationSelect.descripcion
 //       {
 //       keyword = a
 //       }
        
        
        let photoURL = base  + "&location=" + lat + "," + lon + radius + "&keyword=" + keyword
        
        print(photoURL)
        
        let request = URLRequest(url: URL(string: photoURL)!)
        
        print(photoURL)
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data=data else {
                
                complitionHandler (nil,response,error)
                return
                
            }
            
            print("DATA IMPRESION")
            print(data)
            complitionHandler (data,nil,nil)
            
            
        }
        
        task.resume()
    }
    

    class  func readData (data: Data)  {
        
        let decoder = JSONDecoder ()
        //       let resutlados: [StudentInformation]
  //      let data2=data.dropFirst(14)
   //     let data3=data2.dropLast(1)
        
        
        //    let decoData = try! decoder.decode(rspstat.self, from: data3)
        
       // do {
        
     
        
        do {
            let decoData = try decoder.decode(googleRespone.self, from: data)
            print(decoData.status)
            print(decoData.results)
            print("DECODATA PAGES")
     
      

           
            
            for elemento in decoData.results
            {
            
                
             
            let poi = poinOfInterest (title: interestLocations.shared.locationSelectKeyword,
                                      locationName: elemento.name,
                                      keywordK: "Sculpture",
                                      coordinate: CLLocationCoordinate2D(latitude: elemento.geometry.location.lat, longitude: elemento.geometry.location.lng))
            
            interestLocations.shared.locationsGoogle.append(poi)
                print("Nuevo Elemento Agregado")
            
            }
            
            } catch {
                
                print("Error decoding data")
                print(error.localizedDescription)
                
        }
      /*
        } catch {
            
            print("Error decoding data")
            print(error.localizedDescription)
            
        }
        */
        
    }
  
    /*
    
    class  func collectionGenerator () {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "download"), object: nil)
        
        photoApi.requestData { (data,response, error) in
            
            guard let data=data else {
                print("NO DATA ERROR")
                return
            }
            
            print("Data Cargo")
            print(data)
            
            photoApi.readData(data: data)
            
            // ----------------------------------------------------------------------------------------------
            // GENERAR LINKS FL
            // USAR LINK BAJAR FOTO
            // GUARDAR FOTOS EN PERSISTENT STORE
            
            //   photoInfo.collectionGenerator()
            //  ---------------------------------------------------------------------------------------------
            
            var c: Int = 0
            
            // mmmmmmmmmmm
            
            // ACCESO SEGURO AL CONTEXTO
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            
            // ---- SAVING PAGE AND PAGES IN CORE DATA
            
            
            
            var pintoUpdate = Pin(context: managedContext)
            
            photoInfo.shared.pinSelected.page = Int16(photoInfo.shared.page)
            photoInfo.shared.pinSelected.pages = Int16(photoInfo.shared.pages)
            pintoUpdate = photoInfo.shared.pinSelected
            try? managedContext.save()
            
            print ("PIN SELECTED INFO")
            print (photoInfo.shared.pinSelected)
            
            
            
            // mmmmmmmmmmmmmmmmm
            
            print("Collection count: \(photoInfo.shared.collection.count)")
            
            if photoInfo.shared.collection.isEmpty
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nopictures"), object: nil)
            }
            
            for index in photoInfo.shared.collection {
                
                let ImagenURL = "https://farm\(photoInfo.shared.collection[c].farm).staticflickr.com/\(photoInfo.shared.collection[c].server)/\(photoInfo.shared.collection[c].id)_\(photoInfo.shared.collection[c].secret)_m.jpg"
                let imagenTemp = photoInfo.imageDownload(UrlString: ImagenURL)
                
                //  let imagenTemp = UIImage(named: "duck.jpg")
                
                
                let temp = toSaveDisplay(Imagen: imagenTemp.pngData(), ImagenURL: ImagenURL, photoID: photoInfo.shared.collection[c].id, userID: photoInfo.shared.collection[c].owner)
                photoInfo.shared.collectionImage.append(temp)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                
                // mmmmmmmmmmmmmmmm
                // SAVING TO CORE DATA
                
                var photof = Photo(context: managedContext)
                photof.pin = photoInfo.shared.pinSelected
                // photof.imagen = photoInfo.shared.collectionImage[c].Imagen?.
                photof.imagen = photoInfo.shared.collectionImage[c].Imagen
                photof.imageURL = photoInfo.shared.collectionImage[c].ImagenURL
                photof.photoID = photoInfo.shared.collectionImage[c].photoID
                photof.userID = photoInfo.shared.collectionImage[c].userID
                try? managedContext.save()
                
                // mmmmmmmmmmmmmmmmmmm
                
                
                
                print ("Saved \(c) photo")
                c+=1
                
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enddownload"), object: nil)
            //while c <  photoInfo.shared.collection.count - 1
            
            // ----------------------------------------------------------------------------------------------
            
            
            
            
        }
        
        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        // if photoInfo.shared.collection.isEmpty {
        
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nopictures"), object: nil)
        
        //   }
        
    }
 
 */
    
}
