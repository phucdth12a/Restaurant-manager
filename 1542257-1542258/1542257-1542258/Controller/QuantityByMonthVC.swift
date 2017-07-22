//
//  QuantityByMonthVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/21/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class QuantityByMonthVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: *** UI Elements
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblMonthValue: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: *** UI Events
    @IBAction func segment_Tapped(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    // MARK: *** Data model
    var month = Date()
    var listBills = [Bill]()
    var bills = [Bill]()
    var dateFormatter = DateFormatter()
    var data = [RevenueMonth]()
    var dataFoods = [QuantityOfProduct]()
    var dataDrinks = [QuantityOfProduct]()
    
    let calendar = Calendar.current
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        segment.setTitle(NSLocalizedString("foodTypeFood", comment: ""), forSegmentAt: 0)
        segment.setTitle(NSLocalizedString("foodTypeDrink", comment: ""), forSegmentAt: 1)
        
        lblTitle.text = NSLocalizedString("lblStaticsOfProcuct", comment: "")
        lblMonth.text = NSLocalizedString("lblMonth", comment: "")
        
        dateFormatter.locale = Locale(identifier: "vi-VN")
        dateFormatter.dateFormat = "MM/yyy"
        
        lblMonthValue.text = dateFormatter.string(from: month)
        
        listBills = Bill.all() as! [Bill]
        for bill in listBills {
            if dateFormatter.string(from: month) == dateFormatter.string(from: bill.created! as Date) {
                
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuantityByMonthCell", for: indexPath) as! QuantityByMonthCell
        
        cell.lblNameValue.text = name
        cell.lblNumber.text = NSLocalizedString("radioQuantity", comment: "")
        cell.lblNumberValue.text = "\(number)"
        
        return cell
    }
}
