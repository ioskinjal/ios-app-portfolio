//
//  ProductList+CoreDataProperties.swift
//  LevelShoes
//
//  Created by kanhiya kumar jha on 18/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
//

import Foundation
import CoreData


extension ProductList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductList> {
        return NSFetchRequest<ProductList>(entityName: "ProductList")
    }

    @NSManaged public var categoryId: String?
    @NSManaged public var catName: String?
    @NSManaged public var genderID: String?
    @NSManaged public var parentCatId: String?
    @NSManaged public var parentCatName: String?
    @NSManaged public var linkType: String?
    @NSManaged public var linkCatIds: String?

}
