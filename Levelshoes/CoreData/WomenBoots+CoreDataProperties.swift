//
//  WomenBoots+CoreDataProperties.swift
//  LevelShoes
//
//  Created by Maa on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
//

import Foundation
import CoreData


extension WomenBoots {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WomenBoots> {
        return NSFetchRequest<WomenBoots>(entityName: "WomenBoots")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
