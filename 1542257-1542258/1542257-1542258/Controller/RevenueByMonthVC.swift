//
//  RevenueByMonthVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/19/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

struct RevenueMonth {
    
    var date: Int
    var money: Double
}

class RevenueByMonthVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: *** UI Elements
    @IBOutlet weak var lblTotalMoney: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblMonthValue: UILabel!
    
    // MARK: *** Data model
    var month = Date()
    var listBills = [Bill]()
    var bills = [Bill]()
    var dateFormatter = DateFormatter()
    var totalMoney = 0.0
    var data = [RevenueMonth]()
    
    let calendar = Calendar.current

    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTotalMoney.text = NSLocalizedString("lblTotalMoney", comment: "")
        lblMonth.text = NSLocalizedString("lblMonth", comment: "")
        
        dateFormatter.locale = Locale(identifier: "vi-VN")
        dateFormatter.dateFormat = "MM/yyy"
        
        lblMonthValue.text = dateFormatter.string(from: month)
        
        listBills = Bill.all() as! [Bill]
        for bill in listBills {
            if dateFormatter.string(from: month) == dateFormatter.string(from: bill.created! as Date) {
                
                var flag = false
                totalMoney += bill.totalMoney

                let components = calendar.dateComponents([.day], from: bill.created! as Date)
                for i in 0..<data.count {
                    if data[i].date == components.day! {
                        data[i].money += bill.totalMoney
                        flag = true
                    }
                }
                
                if flag == false {
                    let revenueMonth = RevenueMonth(date: components.day!, money: bill.totalMoney)
                    data.append(revenueMonth)
                }
            }
        }
        
        lblMoney.text = "\(totalMoney)$"

    }
    
    
    
    // MARK: *** UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dt = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RevenueByMonthCell", for: indexPath) as! RevenueByMonthCell
        let dateString = NSLocalizedString("lblDate", comment: "")
        cell.lblDate.text = "\(dateString) \(dt.date): "
        cell.lblMoney.text = "\(dt.money)$"
        
        return cell
        
    }
}
