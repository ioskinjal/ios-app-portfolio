//
//  WomenChildData+CoreDataProperties.swift
//  
//
//  Created by Maa on 07/07/20.
//
//

import Foundation
import CoreData


extension WomenChildData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WomenChildData> {
        return NSFetchRequest<WomenChildData>(entityName: "WomenChildData")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var womensChild: WomenData?

}
