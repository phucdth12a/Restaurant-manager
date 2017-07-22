//
//  Currency+CoreDataClass.swift
//  1542257-1542258
//
//  Created by Phu on 4/17/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation
import CoreData


public class Currency: NSManagedObject {
    static let entityName = "Currency"
    
    // Lấy tất cả danh sách
    static func all() -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            return list
        } catch let error as NSError {
            print("Cannot get all from entity \(entityName), error: \(error), \(error.userInfo)")
            return []
        }
    }
    
    // Tạo mới một đối tượng để chèn vào CSDl
    static func create() -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: DB.MOC)
    }

}
