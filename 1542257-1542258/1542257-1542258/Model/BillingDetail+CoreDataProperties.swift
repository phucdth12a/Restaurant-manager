//
//  BillingDetail+CoreDataProperties.swift
//  1542257-1542258
//
//  Created by Phu on 4/21/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation
import CoreData


extension BillingDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BillingDetail> {
        return NSFetchRequest<BillingDetail>(entityName: "BillingDetail")
    }

    @NSManaged public var money: Double
    @NSManaged public var number: Int16
    @NSManaged public var toBill: Bill?
    @NSManaged public var toFood: Food?

}
