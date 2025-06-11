//
//  Recentitemsearch+CoreDataProperties.swift
//  LevelShoes
//
//  Created by kanhiya kumar jha on 14/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
//

import Foundation
import CoreData


extension Recentitemsearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recentitemsearch> {
        return NSFetchRequest<Recentitemsearch>(entityName: "Recentitemsearch")
    }

    @NSManaged public var categoryname: String?
    @NSManaged public var searchtext: String?
    @NSManaged public var language: String?
    @NSManaged public var id: Int32

}
