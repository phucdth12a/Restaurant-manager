//
//  Food+CoreDataProperties.swift
//  1542257-1542258
//
//  Created by Phu on 4/21/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var describe: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var type: Bool
    @NSManaged public var toBillingDetails: NSSet?
    @NSManaged public var toImages: NSSet?
    @NSManaged public var toOrders: NSSet?
    @NSManaged public var toTables: NSSet?

}

// MARK: Generated accessors for toBillingDetails
extension Food {

    @objc(addToBillingDetailsObject:)
    @NSManaged public func addToToBillingDetails(_ value: BillingDetail)

    @objc(removeToBillingDetailsObject:)
    @NSManaged public func removeFromToBillingDetails(_ value: BillingDetail)

    @objc(addToBillingDetails:)
    @NSManaged public func addToToBillingDetails(_ values: NSSet)

    @objc(removeToBillingDetails:)
    @NSManaged public func removeFromToBillingDetails(_ values: NSSet)

}

// MARK: Generated accessors for toImages
extension Food {

    @objc(addToImagesObject:)
    @NSManaged public func addToToImages(_ value: Image)

    @objc(removeToImagesObject:)
    @NSManaged public func removeFromToImages(_ value: Image)

    @objc(addToImages:)
    @NSManaged public func addToToImages(_ values: NSSet)

    @objc(removeToImages:)
    @NSManaged public func removeFromToImages(_ values: NSSet)

}

// MARK: Generated accessors for toOrders
extension Food {

    @objc(addToOrdersObject:)
    @NSManaged public func addToToOrders(_ value: Order)

    @objc(removeToOrdersObject:)
    @NSManaged public func removeFromToOrders(_ value: Order)

    @objc(addToOrders:)
    @NSManaged public func addToToOrders(_ values: NSSet)

    @objc(removeToOrders:)
    @NSManaged public func removeFromToOrders(_ values: NSSet)

}

// MARK: Generated accessors for toTables
extension Food {

    @objc(addToTablesObject:)
    @NSManaged public func addToToTables(_ value: Table)

    @objc(removeToTablesObject:)
    @NSManaged public func removeFromToTables(_ value: Table)

    @objc(addToTables:)
    @NSManaged public func addToToTables(_ values: NSSet)

    @objc(removeToTables:)
    @NSManaged public func removeFromToTables(_ values: NSSet)

}
