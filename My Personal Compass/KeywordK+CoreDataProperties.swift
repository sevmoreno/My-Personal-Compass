//
//  KeywordK+CoreDataProperties.swift
//  My Personal Compass
//
//  Created by Juan Moreno on 6/29/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//
//

import Foundation
import CoreData


extension KeywordK {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KeywordK> {
        return NSFetchRequest<KeywordK>(entityName: "KeywordK")
    }

    @NSManaged public var descripcion: String?
    @NSManaged public var estado: Bool

}
