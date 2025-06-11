//
//  SortBy+CoreDataProperties.swift
//  
//
//  Created by Kinjal.Gadhia on 07/07/20.
//
//

import Foundation
import CoreData


extension SortBy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SortBy> {
        return NSFetchRequest<SortBy>(entityName: "SortBy")
    }

    @NSManaged public var label: String?
    @NSManaged public var sort_order: Int16
    @NSManaged public var value: String?

}
