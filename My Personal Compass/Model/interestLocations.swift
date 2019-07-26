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
    
    var seleccionPOI = poinOfInterest (title: "", locationName: "", keywordC: "", coordinate: CLLocationCoordinate2DMake(0.0, 0.0), placeAD: "")
    
   var locationsGoogle = [poinOfInterest] ()
    
   var collection = [KeywordK] ()

   var googleresults = [ggoogleApi] ()
    
    var colleccionLista = [Iintrest] ()
    
    var iniceLista: Int = 0
   
    
    var detailsLocation = googledetails ()
    
    
    var locationSelectKeyword: String = "Beer"
    var locationSelectStatus: Bool =  true
    
    
    
    var lon: Double = 0.0
    var lat: Double = 0.0
    
    var page: Int = 0
    var pages: Int = 0
    

    
    private init() { }
    
    
   
}
 

