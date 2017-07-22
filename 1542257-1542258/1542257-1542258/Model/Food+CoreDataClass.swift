//
//  Food+CoreDataClass.swift
//  1542257-1542258
//
//  Created by Phu on 4/17/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import Foundation
import CoreData


public class Food: NSManagedObject {
    static let entityName = "Food"
    
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
    
    // Lay danh sach food theo type
    static func getFoods(by type: Bool) -> [Food] {
        let fetchRequest: NSFetchRequest<Food> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "type == %@", type as CVarArg)
        
        do {
            let list = try DB.MOC.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Food]
            
            return list
        } catch let error as NSError {
            print("cannot fetch Food, error: \(error), \(error.userInfo)")
            return []
        }
    }
}
