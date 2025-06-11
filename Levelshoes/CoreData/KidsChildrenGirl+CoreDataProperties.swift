//
//  KidsChildrenGirl+CoreDataProperties.swift
//  
//
//  Created by Maa on 06/07/20.
//
//

import Foundation
import CoreData


extension KidsChildrenGirl {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KidsChildrenGirl> {
        return NSFetchRequest<KidsChildrenGirl>(entityName: "KidsChildrenGirl")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var kidsChildrenGirl: Kids?

}
