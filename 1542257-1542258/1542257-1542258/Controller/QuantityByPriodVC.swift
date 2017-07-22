//
//  QuantityByPriodVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/21/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class QuantityByPriodVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: *** UI Elements
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblFromDateValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var lblToDate: UILabel!
    @IBOutlet weak var lblToDateValue: UILabel!
    
    // MARK: *** UI Events
    @IBAction func segment_Tapped(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    // MARK: *** Data model
    var fromDate = Date()
    var toDate = Date()
    var dateFormatter = DateFormatter()
    var bills = [Bill]()
    var dataFoods = [QuantityOfProduct]()
    var dataDrinks = [QuantityOfProduct]()

    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        segment.setTitle(NSLocalizedString("foodTypeFood", comment: ""), forSegmentAt: 0)
        segment.setTitle(NSLocalizedString("foodTypeDrink", comment: ""), forSegmentAt: 1)
        
        lblTitle.text = NSLocalizedString("lblStaticsOfProcuct", comment: "")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        lblFromDate.text = NSLocalizedString("lblFrom", comment: "")
        lblToDate.text = NSLocalizedString("lblTo", comment: "")
        
        lblFromDateValue.text = formatter.string(from: fromDate)
        lblToDateValue.text = formatter.string(from: toDate)
        
        dateFormatter.locale = Locale(identifier: "vi-VN")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let stringFromDate = "\(dateFormatter.string(from: fromDate)) 00:00"
        let stringToDate = "\(dateFormatter.string(from: toDate)) 23:59"
        
        bills = Bill.getBills(from: stringFromDate, to: stringToDate)
        
        for bill in bills {
            let detailBills = bill.toBillingDetails?.allObjects as! [BillingDetail]
            
            for detailBill in detailBills {
                
                if detailBill.toFood?.type == true {
                    
                    var flag = false
                    for i in 0..<dataFoods.count {
                        
                        if dataFoods[i].name == detailBill.toFood?.name! {
                            
                            dataFoods[i].number += Int(detailBill.number)
                            flag = true
                        }
                        
                    }
                    
                    if flag == false {
                        
                        let dataFood = QuantityOfProduct(name: (detailBill.toFood?.name)!, number: Int(detailBill.number))
                        dataFoods.append(dataFood)
                    }
                    
                } else if detailBill.toFood?.type == false {
                    
                    var flag = false
                    for i in 0..<dataDrinks.count {
                        
                        if dataDrinks[i].name == detailBill.toFood?.name! {
                            
                            dataDrinks[i].number += Int(detailBill.number)
                            flag = true
                        }
                        
                    }
                    
                    if flag == false {
                        
                        let dataDrink = QuantityOfProduct(name: (detailBill.toFood?.name)!, number: Int(detailBill.number))
                        dataDrinks.append(dataDrink)
                    }
                    
                }
            }
        }

        
    }
    
    // MARK: *** UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
            return dataFoods.count
        }
        
        return dataDrinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dt: QuantityOfProduct?
        
        if segment.selectedSegmentIndex == 0 {
            dt = dataFoods[indexPath.row]
        } else {
            dt = dataDrinks[indexPath.row]
        }
        
        let name = (dt?.name)!
        let number = (dt?.number)!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuantityByPriodCell", for: indexPath) as! QuantityByPriodCell
        
        cell.lblNameValue.text = name
        cell.lblNumber.text = NSLocalizedString("radioQuantity", comment: "")
        cell.lblNumberValue.text = "\(number)"
        
        return cell
    }


}
