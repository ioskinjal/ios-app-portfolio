//
//  KidsChildrenBoy+CoreDataProperties.swift
//  
//
//  Created by Maa on 06/07/20.
//
//

import Foundation
import CoreData


extension KidsChildrenBoy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KidsChildrenBoy> {
        return NSFetchRequest<KidsChildrenBoy>(entityName: "KidsChildrenBoy")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var kidsChildrenBoy: Kids?

}
