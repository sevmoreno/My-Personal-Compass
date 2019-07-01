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
import Contacts


class ggoogleApi {
    
    static let base: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?&key=AIzaSyAjt6INZiPH-K3DyI-WvVZRiBj-cCWPobQ"
    
    
    // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=YOUR_API_KEY
    
    static var lat: String = "34.0194"
    static var lon: String = "-118.411"
    static let city = "&accuracy=11"
    static var radius = "&radius=1500"
    static var keyword = "beer"

    
    
    
    class func requestData (palabraK: String, complitionHandler: @escaping (Data?,URLResponse?,Error?,String) -> Void) {
        
        lat = String (interestLocations.shared.lat)
        lon = String (interestLocations.shared.lon)
   
        
        keyword = palabraK
        
        
        let photoURL = base  + "&location=" + lat + "," + lon + radius + "&keyword=" + keyword
        
       // print(photoURL)
        
        let request = URLRequest(url: URL(string: photoURL)!)
        
        print("Palabra EN requesData: \(keyword)")
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data=data else {
                
                complitionHandler (nil,response,error,keyword)
                return
                
            }
            
            print("DATA IMPRESION")
            print(data)
            complitionHandler (data,nil,nil,keyword)
            
            
        }
        
        task.resume()
    }
    

    class  func readData (data: Data, palabra: String)  {
        
        let decoder = JSONDecoder ()

        
     
        
        do {
            let decoData = try decoder.decode(googleRespone.self, from: data)
         //   print(decoData.status)
         //   print(decoData.results)
         //   print("DECODATA PAGES")
     
      

           
            
            for elemento in decoData.results
            {
            
           print("Palabra EN readData: \(palabra)")
             
            let poi = poinOfInterest (title: palabra,
                                      locationName: elemento.name ,
                                      keywordC: "Sculpture",
                                      coordinate: CLLocationCoordinate2D(latitude: elemento.geometry.location.lat, longitude: elemento.geometry.location.lng))
            
            interestLocations.shared.locationsGoogle.append(poi)
                print("Nuevo Elemento Agregado")
            
            }
            
            } catch {
                
                print("Error decoding data")
                print(error.localizedDescription)
                
        }

        
    }
  
    
}
