//
//  CurrencyVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

protocol CurrencyControllerDelegate {
    func addCurrency(newCurrency: Currency)
}

class CurrencyVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CurrencyControllerDelegate {
    
    
    // MARK: *** Data model
    var currencys = [NSManagedObject]()
    
    
    // MARK: *** UI Elements
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("titleCurrency", comment: "")
        
        if revealViewController() != nil {
            btnMenu.target = revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        currencys = Currency.all()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewCurrencyID" {
            let dest = segue.destination as! DetailCurrencyVC
            dest.model = "Add"
            dest.delegate = self
        } else if segue.identifier == "EditCurrencyID" {
            let dest = segue.destination as! DetailCurrencyVC
            dest.model = "Edit"
            dest.currency = selectedCurrency
        }
    }
    
    func addCurrency(newCurrency: Currency) {
        currencys += [newCurrency]
    }
    
    
    
    // MARK: *** UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = currencys[indexPath.row] as! Currency
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        
        cell.lblType.text = currency.type
        cell.lblRate.text = String(currency.exchangeRate)
        
        return cell
    }
    
    var selectedCurrency: Currency?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCurrency = currencys[indexPath.row] as? Currency
        performSegue(withIdentifier: "EditCurrencyID", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let currency = currencys[indexPath.row]
            DB.MOC.delete(currency)
            currencys.remove(at: indexPath.row)
            
            DB.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
