//
//  KidsChildrenBaby+CoreDataProperties.swift
//  
//
//  Created by Maa on 06/07/20.
//
//

import Foundation
import CoreData


extension KidsChildrenBaby {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KidsChildrenBaby> {
        return NSFetchRequest<KidsChildrenBaby>(entityName: "KidsChildrenBaby")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var kidsChildrenBaby: Kids?

}
