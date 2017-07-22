//
//  CounterVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

protocol CounterControllerDelegate {
    func addCounter(newCounter: Counter)
}

class CounterVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CounterControllerDelegate {

    // MARK: *** Data model
    var counters = [NSManagedObject]()
    
    // MARK: *** UI Elements
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("titleCounter", comment: "")

        if revealViewController() != nil {
            btnMenu.target = revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        counters = Counter.all()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewCounterID" {
            let dest = segue.destination as! DetailCounterVC
            dest.model = "Add"
            dest.delegate = self
        } else if segue.identifier == "EditCounterID" {
            let dest = segue.destination as! DetailCounterVC
            dest.model = "Edit"
            dest.counter = selectedCounter
        }
    }
    
    func addCounter(newCounter: Counter) {
        counters += [newCounter]
    }
    
    //MARK: *** UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let counter = counters[indexPath.row] as! Counter
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CounterCell", for: indexPath) as! CounterCell
        
        cell.lblCounterName.text = counter.name
        cell.lblCounterDescription.text = counter.describe
        
        let counterImages = counter.toImages?.allObjects as! Array<Image>
        if counterImages.count > 0 {
            cell.imageCounter.image = UIImage(data: counterImages[0].data! as Data)
        }
        
        return cell
    }
    
    var selectedCounter: Counter?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCounter = counters[indexPath.row] as? Counter
        performSegue(withIdentifier: "EditCounterID", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let counter = counters[indexPath.row] as! Counter
            
            for item in counter.toImages! {
                let image = item as! Image
                counter.removeFromToImages(image)
                DB.MOC.delete(image)
            }
            
            DB.MOC.delete(counter)
            counters.remove(at: indexPath.row)
            
            DB.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
