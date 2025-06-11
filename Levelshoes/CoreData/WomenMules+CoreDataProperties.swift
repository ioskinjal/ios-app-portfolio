//
//  WomenMules+CoreDataProperties.swift
//  LevelShoes
//
//  Created by Maa on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
//

import Foundation
import CoreData


extension WomenMules {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WomenMules> {
        return NSFetchRequest<WomenMules>(entityName: "WomenMules")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
