//
//  MenChildData+CoreDataProperties.swift
//  
//
//  Created by Maa on 07/07/20.
//
//

import Foundation
import CoreData


extension MenChildData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenChildData> {
        return NSFetchRequest<MenChildData>(entityName: "MenChildData")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var child: MenData?

}
