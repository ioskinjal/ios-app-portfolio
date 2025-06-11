//
//  Women+CoreDataProperties.swift
//  LevelShoes
//
//  Created by Maa on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
//

import Foundation
import CoreData


extension Women {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Women> {
        return NSFetchRequest<Women>(entityName: "Women")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
