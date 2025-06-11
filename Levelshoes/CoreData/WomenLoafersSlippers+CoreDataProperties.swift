//
//  WomenLoafersSlippers+CoreDataProperties.swift
//  LevelShoes
//
//  Created by Maa on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
//

import Foundation
import CoreData


extension WomenLoafersSlippers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WomenLoafersSlippers> {
        return NSFetchRequest<WomenLoafersSlippers>(entityName: "WomenLoafersSlippers")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
