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
    let keywordC: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, keywordC: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.keywordC = keywordC
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
    

    var markerTintColor: UIColor  {
        
        switch keywordC {
        case "Red":
            return .red
        case "Cyan":
            return .cyan
        case "Blue":
            return .blue
        case "Purple":
            return .purple
        default:
            return .red
        }
    }


}

