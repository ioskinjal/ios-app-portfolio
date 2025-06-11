//
//  Cart+CoreDataProperties.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 19/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation

extension Cart{
   
    @NSManaged public var allSKU:String
    @NSManaged public var imageURL:String
    @NSManaged public var productName:String
    @NSManaged public var productPrice:Double
    @NSManaged public var quantity:Double
    @NSManaged public var size:Double
    @NSManaged public var categoryName:String
    @NSManaged public var attributeID:Double
    @NSManaged public var selectedSize:String
}
