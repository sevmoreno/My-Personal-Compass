//
//  googledetails.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 7/16/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation


struct googledetails: Codable {
    
   // var html_attributions: [String]
    var result: result?
   // var status: String

}

struct result: Codable {
    
    var name: String?
    //var rating: Int
    var formatted_phone_number: String?
    
    var formatted_address: String?
    var website: String?
    var photos: [photoA]?
    
    // To Use to Me to creat a new maybe I dont need those
    var lat: Double?
    var long: Double?
}

struct photoA: Codable {
    
    var height: Int
    var html_attributions: [String]
    var photo_reference: String
    var width: Int
}
/*

struct googledetails: Codable {
    var results: [results]
    var status: String
}


struct results: Codable {
    
    
    var geometry: geometry
    var icon: String
    var id: String
    var name: String
    var vicinity: String
    var types: [String]
    //var photos: [photos]
    
}

struct geometry: Codable {
    var location: location
    var viewport: viewport
}

struct location: Codable {
    var lat: Double
    var lng: Double
}

struct viewport: Codable {
    var northeast: northeast
    var southwest: southwest
}

struct northeast: Codable {
    var lat: Double
    var lng: Double
}

struct southwest: Codable {
    var lat: Double
    var lng: Double
}

struct photos: Codable {
    var height: Int
    var width: Int
    var html_attributions: [String]
    var photo_reference: String
 
 */

