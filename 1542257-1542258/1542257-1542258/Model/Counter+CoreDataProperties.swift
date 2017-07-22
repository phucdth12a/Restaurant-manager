//
//  Counter+CoreDataProperties.swift
//  1542257-1542258
//
//  Created by Phu on 4/21/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var describe: String?
    @NSManaged public var name: String?
    @NSManaged public var toImages: NSSet?
    @NSManaged public var toTables: NSSet?

}

// MARK: Generated accessors for toImages
extension Counter {

    @objc(addToImagesObject:)
    @NSManaged public func addToToImages(_ value: Image)

    @objc(removeToImagesObject:)
    @NSManaged public func removeFromToImages(_ value: Image)

    @objc(addToImages:)
    @NSManaged public func addToToImages(_ values: NSSet)

    @objc(removeToImages:)
    @NSManaged public func removeFromToImages(_ values: NSSet)

}

// MARK: Generated accessors for toTables
extension Counter {

    @objc(addToTablesObject:)
    @NSManaged public func addToToTables(_ value: Table)

    @objc(removeToTablesObject:)
    @NSManaged public func removeFromToTables(_ value: Table)

    @objc(addToTables:)
    @NSManaged public func addToToTables(_ values: NSSet)

    @objc(removeToTables:)
    @NSManaged public func removeFromToTables(_ values: NSSet)

}
