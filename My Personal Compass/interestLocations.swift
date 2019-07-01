//
//  interestLocations.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/29/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//
import UIKit
import CoreData
import MapKit

class interestLocations {
    
    
    // Singleton POWER
    
    static let shared = interestLocations ()
    

    
   var locationsGoogle = [poinOfInterest] ()
    
   var collection = [KeywordK] ()

   var googleresults = [ggoogleApi] ()
    
    
    var locationSelectKeyword: String = "Beer"
    var locationSelectStatus: Bool =  true
    
    
    
    var lon: Double = 0.0
    var lat: Double = 0.0
    
    var page: Int = 0
    var pages: Int = 0
    
    /*
     init (photoID: String, farm: Int, server: String, secret: String) {
     self.photoID = photoID
     self.farm = farm
     self.server = server
     self.secret = secret
     }
     */
    
    private init() { }
    
    
   
}
 

