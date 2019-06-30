//
//  poinOfInterest.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/30/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import MapKit
import Contacts


class poinOfInterest: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let keywordK: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, keywordK: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.keywordK = keywordK
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    

}

