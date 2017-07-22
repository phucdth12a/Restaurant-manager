//
//  Table+CoreDataProperties.swift
//  1542257-1542258
//
//  Created by Phu on 4/21/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation
import CoreData


extension Table {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Table> {
        return NSFetchRequest<Table>(entityName: "Table")
    }

    @NSManaged public var infomation: String?
    @NSManaged public var number: Int16
    @NSManaged public var status: Bool
    @NSManaged public var toBills: NSSet?
    @NSManaged public var toCounter: Counter?
    @NSManaged public var toFoods: NSSet?
    @NSManaged public var toImages: NSSet?
    @NSManaged public var toOrders: NSSet?

}

// MARK: Generated accessors for toBills
extension Table {

    @objc(addToBillsObject:)
    @NSManaged public func addToToBills(_ value: Bill)

    @objc(removeToBillsObject:)
    @NSManaged public func removeFromToBills(_ value: Bill)

    @objc(addToBills:)
    @NSManaged public func addToToBills(_ values: NSSet)

    @objc(removeToBills:)
    @NSManaged public func removeFromToBills(_ values: NSSet)

}

// MARK: Generated accessors for toFoods
extension Table {

    @objc(addToFoodsObject:)
    @NSManaged public func addToToFoods(_ value: Food)

    @objc(removeToFoodsObject:)
    @NSManaged public func removeFromToFoods(_ value: Food)

    @objc(addToFoods:)
    @NSManaged public func addToToFoods(_ values: NSSet)

    @objc(removeToFoods:)
    @NSManaged public func removeFromToFoods(_ values: NSSet)

}

// MARK: Generated accessors for toImages
extension Table {

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
extension Table {

    @objc(addToOrdersObject:)
    @NSManaged public func addToToOrders(_ value: Order)

    @objc(removeToOrdersObject:)
    @NSManaged public func removeFromToOrders(_ value: Order)

    @objc(addToOrders:)
    @NSManaged public func addToToOrders(_ values: NSSet)

    @objc(removeToOrders:)
    @NSManaged public func removeFromToOrders(_ values: NSSet)

}
