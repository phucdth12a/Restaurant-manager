//
//  Bill+CoreDataProperties.swift
//  1542257-1542258
//
//  Created by Phu on 4/21/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation
import CoreData


extension Bill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bill> {
        return NSFetchRequest<Bill>(entityName: "Bill")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var totalMoney: Double
    @NSManaged public var toBillingDetails: NSSet?
    @NSManaged public var toTable: Table?

}

// MARK: Generated accessors for toBillingDetails
extension Bill {

    @objc(addToBillingDetailsObject:)
    @NSManaged public func addToToBillingDetails(_ value: BillingDetail)

    @objc(removeToBillingDetailsObject:)
    @NSManaged public func removeFromToBillingDetails(_ value: BillingDetail)

    @objc(addToBillingDetails:)
    @NSManaged public func addToToBillingDetails(_ values: NSSet)

    @objc(removeToBillingDetails:)
    @NSManaged public func removeFromToBillingDetails(_ values: NSSet)

}
