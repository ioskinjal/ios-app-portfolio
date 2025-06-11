//
//  WomenJewellery+CoreDataProperties.swift
//  LevelShoes
//
//  Created by Maa on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
//

import Foundation
import CoreData


extension WomenJewellery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WomenJewellery> {
        return NSFetchRequest<WomenJewellery>(entityName: "WomenJewellery")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
