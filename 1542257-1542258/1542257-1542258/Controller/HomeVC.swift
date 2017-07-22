//
//  HomeVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

protocol HomeTableControllerDelegate {
    func doneAction()
}

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HomeTableControllerDelegate {
    
    // MARK: *** UI Elements
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: *** Data model
    var counters = [Counter]()
    var tables = [[Table]]()

    // MARK: *** UIViewController
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailOrderTableID" {
            let dest = segue.destination as! HomeTableVC
            dest.table = selectedtable
            dest.delegate = self
        }
    }
    
    
    // MARK: *** UICollectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionView", for: indexPath) as! HeaderCollectionReusableView
            
            headerView.lblCounter.text = counters[indexPath.section].name
            return headerView
        
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tables.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tables[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let table = tables[indexPath.section][indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let numberofTable = table.number
        cell.lblNumberOfTable.text = String(numberofTable)
        
        if table.status == true {
            cell.imageTable.image = UIImage(named: "table_order")
        } else {
            cell.imageTable.image = UIImage(named: "table_free")
        }
        
        return cell
    }
    
    var selectedtable: Table?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedtable = tables[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "DetailOrderTableID", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = 3
        let spaceBetweenCells: CGFloat = 1
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim)
    }
    
    // MARK: *** HomeTableControllerDelegate
    func doneAction() {
        
        counters.removeAll()
        tables.removeAll()
        
        counters = Counter.all() as! [Counter]
        
        for counter in counters {
            let listTable = counter.toTables?.allObjects as! [Table]
            tables.append(listTable)
        }
        
        self.collectionView.reloadData()

    }

}




