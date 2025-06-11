//
//  Filter+CoreDataProperties.swift
//  
//
//  Created by Kinjal.Gadhia on 07/07/20.
//
//

import Foundation
import CoreData


extension Filter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Filter> {
        return NSFetchRequest<Filter>(entityName: "Filter")
    }

    @NSManaged public var attribute_code: String?
    @NSManaged public var label: String?
    @NSManaged public var sort_order: Int16

}
