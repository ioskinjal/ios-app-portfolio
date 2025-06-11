//
//  Kids+CoreDataProperties.swift
//  
//
//  Created by Maa on 06/07/20.
//
//

import Foundation
import CoreData


extension Kids {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kids> {
        return NSFetchRequest<Kids>(entityName: "Kids")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var baby: NSSet?
    @NSManaged public var boy: NSSet?
    @NSManaged public var girl: NSSet?

}

// MARK: Generated accessors for baby
extension Kids {

    @objc(addBabyObject:)
    @NSManaged public func addToBaby(_ value: KidsChildrenBaby)

    @objc(removeBabyObject:)
    @NSManaged public func removeFromBaby(_ value: KidsChildrenBaby)

    @objc(addBaby:)
    @NSManaged public func addToBaby(_ values: NSSet)

    @objc(removeBaby:)
    @NSManaged public func removeFromBaby(_ values: NSSet)

}

// MARK: Generated accessors for boy
extension Kids {

    @objc(addBoyObject:)
    @NSManaged public func addToBoy(_ value: KidsChildrenBoy)

    @objc(removeBoyObject:)
    @NSManaged public func removeFromBoy(_ value: KidsChildrenBoy)

    @objc(addBoy:)
    @NSManaged public func addToBoy(_ values: NSSet)

    @objc(removeBoy:)
    @NSManaged public func removeFromBoy(_ values: NSSet)

}

// MARK: Generated accessors for girl
extension Kids {

    @objc(addGirlObject:)
    @NSManaged public func addToGirl(_ value: KidsChildrenGirl)

    @objc(removeGirlObject:)
    @NSManaged public func removeFromGirl(_ value: KidsChildrenGirl)

    @objc(addGirl:)
    @NSManaged public func addToGirl(_ values: NSSet)

    @objc(removeGirl:)
    @NSManaged public func removeFromGirl(_ values: NSSet)

}
