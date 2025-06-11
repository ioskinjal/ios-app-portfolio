//
//  WomenSandals+CoreDataProperties.swift
//  LevelShoes
//
//  Created by Maa on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
//

import Foundation
import CoreData


extension WomenSandals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WomenSandals> {
        return NSFetchRequest<WomenSandals>(entityName: "WomenSandals")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
