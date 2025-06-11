//
//  MenSunglasses+CoreDataProperties.swift
//  LevelShoes
//
//  Created by Maa on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
//

import Foundation
import CoreData


extension MenSunglasses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenSunglasses> {
        return NSFetchRequest<MenSunglasses>(entityName: "MenSunglasses")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
