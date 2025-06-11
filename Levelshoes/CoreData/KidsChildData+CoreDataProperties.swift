//
//  KidsChildData+CoreDataProperties.swift
//  
//
//  Created by Maa on 07/07/20.
//
//

import Foundation
import CoreData


extension KidsChildData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KidsChildData> {
        return NSFetchRequest<KidsChildData>(entityName: "KidsChildData")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var child: KidsData?

}
