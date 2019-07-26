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
    var title: String?
    var locationName: String
    var keywordC: String
    var coordinate: CLLocationCoordinate2D
    var placeID: String
    
    
    init(title: String, locationName: String, keywordC: String, coordinate: CLLocationCoordinate2D, placeAD: String) {
        self.title = title
        self.locationName = locationName
        self.keywordC = keywordC
        self.coordinate = coordinate
        self.placeID = placeAD
        
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
            return UIColor(red: .random(in: 0...1),
                               green: .random(in: 0...1),
                               blue: .random(in: 0...1),
                               alpha: 1.0)
            
        }
    }

    

}


