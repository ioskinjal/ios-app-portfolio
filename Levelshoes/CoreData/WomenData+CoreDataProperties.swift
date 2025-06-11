//
//  WomenData+CoreDataProperties.swift
//  
//
//  Created by Maa on 07/07/20.
//
//

import Foundation
import CoreData


extension WomenData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WomenData> {
        return NSFetchRequest<WomenData>(entityName: "WomenData")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var womens: NSSet?

}

// MARK: Generated accessors for womens
extension WomenData {

    @objc(addWomensObject:)
    @NSManaged public func addToWomens(_ value: WomenChildData)

    @objc(removeWomensObject:)
    @NSManaged public func removeFromWomens(_ value: WomenChildData)

    @objc(addWomens:)
    @NSManaged public func addToWomens(_ values: NSSet)

    @objc(removeWomens:)
    @NSManaged public func removeFromWomens(_ values: NSSet)

}
