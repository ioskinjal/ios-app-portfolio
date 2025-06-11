//
//  MenData+CoreDataProperties.swift
//  
//
//  Created by Maa on 07/07/20.
//
//

import Foundation
import CoreData


extension MenData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenData> {
        return NSFetchRequest<MenData>(entityName: "MenData")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var mens: NSSet?

}

// MARK: Generated accessors for mens
extension MenData {

    @objc(addMensObject:)
    @NSManaged public func addToMens(_ value: MenChildData)

    @objc(removeMensObject:)
    @NSManaged public func removeFromMens(_ value: MenChildData)

    @objc(addMens:)
    @NSManaged public func addToMens(_ values: NSSet)

    @objc(removeMens:)
    @NSManaged public func removeFromMens(_ values: NSSet)

}
