//
//  RevenueByDateVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/18/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

class RevenueByDateVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: *** UI Elements
    @IBOutlet weak var lblToltalMoney: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDateValue: UILabel!
    
    // MARK: *** Data model
    var date = Date()
    var listBills = [Bill]()
    var bills = [Bill]()
    var dateFormatter = DateFormatter()
    var totalMoney = 0.0

    // MARK: *** ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblToltalMoney.text = NSLocalizedString("lblTotalMoney", comment: "")
        lblDate.text = NSLocalizedString("lblDate", comment: "")
        
        dateFormatter.locale = Locale(identifier: "vi-VN")
        dateFormatter.dateFormat = "dd/MM/yyy"
        
        lblDateValue.text = dateFormatter.string(from: date)
        
        listBills = Bill.all() as! [Bill]
        for bill in listBills {
            if dateFormatter.string(from: date) == dateFormatter.string(from: bill.created! as Date) {
                bills += [bill]
                totalMoney += bill.totalMoney
            }
        }
        
        lblMoney.text = "\(totalMoney)$"
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bill = bills[indexPath.row]
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "RevenueByDateCell", for: indexPath) as! RevenueByDateCell
        
        cell.lblTien.text = "\((bill.totalMoney))$"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: bill.created! as Date)
        
        cell.lblTime.text = "\(components.hour!):\(components.minute!):\(components.second!)"
        cell.lblNameTable.text = "\((bill.toTable?.number)!)"
        
        let tableImages = bill.toTable?.toImages?.allObjects as! [Image]
        if tableImages.count > 0 {
            cell.imageTable.image = UIImage(data: tableImages[0].data! as Data)
        }

        
        return cell
    }

}
