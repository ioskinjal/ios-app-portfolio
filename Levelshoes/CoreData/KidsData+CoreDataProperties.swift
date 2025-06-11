//
//  KidsData+CoreDataProperties.swift
//  
//
//  Created by Maa on 07/07/20.
//
//

import Foundation
import CoreData


extension KidsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KidsData> {
        return NSFetchRequest<KidsData>(entityName: "KidsData")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var kids: NSSet?

}

// MARK: Generated accessors for kids
extension KidsData {

    @objc(addKidsObject:)
    @NSManaged public func addToKids(_ value: KidsChildData)

    @objc(removeKidsObject:)
    @NSManaged public func removeFromKids(_ value: KidsChildData)

    @objc(addKids:)
    @NSManaged public func addToKids(_ values: NSSet)

    @objc(removeKids:)
    @NSManaged public func removeFromKids(_ values: NSSet)

}
