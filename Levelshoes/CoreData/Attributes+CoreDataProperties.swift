//
//  Attributes+CoreDataProperties.swift
//  
//
//  Created by apple on 7/11/20.
//
//

import Foundation
import CoreData


extension Attributes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attributes> {
        return NSFetchRequest<Attributes>(entityName: "Attributes")
    }

    @NSManaged public var attribute_code: String?
    @NSManaged public var options: NSObject?

}
