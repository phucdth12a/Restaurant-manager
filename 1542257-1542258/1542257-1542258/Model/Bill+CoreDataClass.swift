//
//  Bill+CoreDataClass.swift
//  1542257-1542258
//
//  Created by Phu on 4/17/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation
import CoreData


public class Bill: NSManagedObject {
    static let entityName = "Bill"
    
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
    
    // Lay danh sach Bill trong khoang ngay
    static func getBills(from: String, to: String) -> [Bill] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "vi-VN")
        
        let startDate = dateFormatter.date(from: from)
        let endDate = dateFormatter.date(from: to)
        
        let fetchRequest: NSFetchRequest<Food> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "(created >= %@) AND (created <= %@)", startDate! as CVarArg, endDate! as CVarArg)
        
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Bill]
            
            return list
        } catch let error as NSError {
            print("cannot fetch Food, error: \(error), \(error.userInfo)")
            return []
        }
    }

}
