//
//  RecentSearch+CoreDataProperties.swift
//  
//
//  Created by Maa on 06/07/20.
//
//

import Foundation
import CoreData


extension RecentSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearch> {
        return NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
    }

    @NSManaged public var name: String?

}
