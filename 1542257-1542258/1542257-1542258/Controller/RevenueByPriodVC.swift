//
//  RevenueByPriodVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/20/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

struct RevenuePriod {
    
    var date: String
    var money: Double
}

class RevenueByPriodVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: *** UI Elements
    @IBOutlet weak var lblTotalMoney: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblToDate: UILabel!

    // MARK: *** Data model
    var fromDate = Date()
    var toDate = Date()
    var dateFormatter = DateFormatter()
    var totalMoney = 0.0
    var bills = [Bill]()
    var data = [RevenuePriod]()
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        lblTotalMoney.text = NSLocalizedString("lblTotalMoney", comment: "")
        lblFrom.text = NSLocalizedString("lblFrom", comment: "")
        lblTo.text = NSLocalizedString("lblTo", comment: "")
        
        lblFromDate.text = formatter.string(from: fromDate)
        lblToDate.text = formatter.string(from: toDate)
        
        dateFormatter.locale = Locale(identifier: "vi-VN")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let stringFromDate = "\(dateFormatter.string(from: fromDate)) 00:00"
        let stringToDate = "\(dateFormatter.string(from: toDate)) 23:59"
        
        bills = Bill.getBills(from: stringFromDate, to: stringToDate)
        
        for bill in bills {
            
            totalMoney += bill.totalMoney
            
            var flag = false
            for i in 0..<data.count {

                if data[i].date == formatter.string(from: bill.created! as Date) {
                    
                    data[i].money += bill.totalMoney
                    flag = true
                }
            }
            
            if flag == false {
                let revenuePriod = RevenuePriod(date: formatter.string(from: bill.created! as Date), money: bill.totalMoney)
                data.append(revenuePriod)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RevenueByPriodCell", for: indexPath) as! RevenueByPriodCell
        let dateString = NSLocalizedString("lblDate", comment: "")
        cell.lblDate.text = "\(dateString) \(dt.date)"
        cell.lblMoney.text = "\(dt.money)$"
        
        return cell
    }

}
