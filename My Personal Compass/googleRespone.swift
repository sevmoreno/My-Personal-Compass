//
//  googleRespone.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/29/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation


struct googleRespone: Codable {
    var results: [results]
    var status: String    
}


struct results: Codable {
    var geometry: geometry
    var icon: String
    var id: String
    var name: String
    
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
