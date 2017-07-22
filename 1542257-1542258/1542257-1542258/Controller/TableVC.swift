//
//  TableVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

protocol TableControllerDelegate {
    func doneTable()
}

class TableVC: UIViewController, UITableViewDataSource, UITableViewDelegate, TableControllerDelegate {
    
    // MARK: *** Data model
    var counters = [Counter]()
    var tables = [[Table]]()
    
    // MARK: *** UI Elements
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("titleTable", comment: "")
        
        if revealViewController() != nil {
            btnMenu.target = revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        }

        counters = Counter.all() as! [Counter]
        
        for counter in counters {
            let listTable = counter.toTables?.allObjects as! [Table]
            tables.append(listTable)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewTableID" {
            let dest = segue.destination as! DetailTableVC
            dest.model = "Add"
            dest.delegate = self
        } else if segue.identifier == "EditTableID" {
            let dest = segue.destination as! DetailTableVC
            dest.model = "Edit"
            dest.table = selectedTable
            dest.delegate = self
        }
    }
    
    // MARK: *** UITableView
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return counters[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = tables[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        
        let numberofTable: Int = Int(table.number)
        cell.lblNumberTable.text = String(numberofTable)
        cell.lblDescriptionTable.text = table.infomation
        
        let tableImages = table.toImages?.allObjects as! Array<Image>
        if tableImages.count > 0 {
            cell.imageTable.image = UIImage(data: tableImages[0].data! as Data)
        }
        
        return cell
    }
    
    var selectedTable: Table?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTable = tables[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "EditTableID", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let table = tables[indexPath.section][indexPath.row]
            
            for item in table.toImages! {
                let image = item as! Image
                table.removeFromToImages(image)
                DB.MOC.delete(image)
            }
            
            DB.MOC.delete(table)
            tables[indexPath.section].remove(at: indexPath.row)
            
            DB.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    // MARK: *** TableControllerDelegate
    func doneTable() {
        
        tables.removeAll()
        for counter in counters {
            let listTable = counter.toTables?.allObjects as! [Table]
            tables.append(listTable)
        }
    }

}
