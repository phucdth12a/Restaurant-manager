//
//  DB.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

class DB {
    
    // Truy cập đến đối tượng object context chung
    static var MOC: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Hàm giúp lưu
    static func save() {
        if MOC.hasChanges {
            do {
                try MOC.save()
            }
            catch let error as NSError {
                print("Cannot save db \(error)")
            }
        }
    }

    
}
