//
//  HomeTableVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/16/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

protocol OrderControllerDelegate {
    func doneEdit()
    func doneOrder()
}

class HomeTableVC: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, OrderControllerDelegate {

    // MARK: *** UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotalMoney: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnAddFood: UIButton!
    @IBOutlet weak var txtTypeCurrency: UITextField!
    
    let currencyPickerView = UIPickerView()
    
    // MARK: *** UI Events
    @IBAction func btnCancel_Tapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: NSLocalizedString("alertOpenTable", comment: ""), message: NSLocalizedString("contentCancelTable", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (UIAlertAction) in
            for dt in self.data {
                
                let food = dt.food
                let order = dt.order
                
                food.removeFromToOrders(order)
                self.table?.removeFromToOrders(order)
                self.table?.removeFromToFoods(food)
                
                DB.MOC.delete(order)
                
                DB.save()
                
            }
            self.table?.status = false
            DB.save()
            self.delegate?.doneAction()
            _ = self.navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("btnCancelOpenTable", comment: ""), style: .default, handler: { (UIAlertAction) in
            
            
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)

        
    }
    
    @IBAction func btnPay_Tapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: NSLocalizedString("alertOpenTable", comment: ""), message: NSLocalizedString("contentPayTable", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (UIAlertAction) in
            
            if self.data.count > 0 {
                let newBill = Bill.create() as! Bill
                newBill.created = Date() as NSDate?
                newBill.totalMoney = self.finalMoney
                self.table?.addToToBills(newBill)
            
                for dt in self.data {
                
                    let food = dt.food
                    let order = dt.order
                
                    let newBillingDetail = BillingDetail.create() as! BillingDetail
                    newBillingDetail.number = order.number
                    newBillingDetail.money = Double(order.number) * food.price
                    newBillingDetail.toFood = food
                
                    newBill.addToToBillingDetails(newBillingDetail)
                
                    food.removeFromToOrders(order)
                    self.table?.removeFromToOrders(order)
                    self.table?.removeFromToFoods(food)
                
                    DB.MOC.delete(order)
                
                    DB.save()
                
                }
            }
            
            self.table?.status = false
            DB.save()
            self.delegate?.doneAction()
            _ = self.navigationController?.popViewController(animated: true)
            
            
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("btnCancelOpenTable", comment: ""), style: .default, handler: { (UIAlertAction) in
            
            
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnAddFood_Tapped(_ sender: UIButton) {
    }
    
    
    // MARK: *** Data model
    var table: Table?
    var foods = [Food]()
    var finalMoney: Double = 0.0
    var currencys = [Currency]()
    
    var data = [orderFood]()
    var dataOrder = [orderFood]()
    var delegate: HomeTableControllerDelegate?
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let number: Int = Int((table?.number)!)
        self.title = "\(number)"

        btnCancel.setTitle(NSLocalizedString("btnCancel", comment: ""), for: .normal)
        btnPay.setTitle(NSLocalizedString("btnPay", comment: ""), for: .normal)
        btnAddFood.setTitle(NSLocalizedString("btnAddFood", comment: ""), for: .normal)
        
        
        if table?.status == false {
            let alert = UIAlertController(title: NSLocalizedString("alertOpenTable", comment: ""), message: NSLocalizedString("contentOpenTable", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (UIAlertAction) in
                self.table?.status = true
                DB.save()
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("btnCancelOpenTable", comment: ""), style: .default, handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        foods = table?.toFoods?.allObjects as! [Food]
        
        for food in foods {
            let listorderFood = food.toOrders?.allObjects as! [Order]
            let listorderTable = table?.toOrders?.allObjects as! [Order]
            
            for order in listorderFood {
                if let _ = listorderTable.index(of: order) {
                    let orderNewFood = orderFood(food: food, order: order)
                    data.append(orderNewFood)
                }
            }
        }
        
        currencys = Currency.all() as! [Currency]
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        txtTypeCurrency.inputView = currencyPickerView
        
        txtTypeCurrency.text = "USD"
        
        lblTotalMoney.text = "\(NSLocalizedString("lblTotalMoney", comment: "")): \(finalMoney)$"
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewOrderFoodID" {
            let dest = segue.destination as! ChooseFoodVC
            dest.table = table
            dest.delegate = self
        } else if segue.identifier == "" {
            
        }
    }
    
    // MARK: *** UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = data[indexPath.row].food
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableCell
        
        let price: Double = food.price
        let order: Order = data[indexPath.row].order
        let number = order.number
        cell.number = Int(number)
        cell.price = price
        cell.lblMoney.text = "\(price)$"
        cell.lblTotalMoney.text = "\(price * Double(number))$"
        cell.lblNameFood.text = food.name
        
        if number < 10 {
            cell.lblNumber.text = "0\(number)"
        } else {
            cell.lblNumber.text = "\(number)"
        }
        
        cell.delegate = self
        
        let foodImages = food.toImages?.allObjects as! Array<Image>
        if foodImages.count > 0 {
            cell.imageTable.image = UIImage(data: foodImages[0].data! as Data)
        }
        self.finalMoney += (price * Double(number))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let food = data[indexPath.row].food
            let order = data[indexPath.row].order
            
            table?.removeFromToOrders(order)
            food.removeFromToOrders(order)
            table?.removeFromToFoods(food)
            
            DB.MOC.delete(order)
            
            DB.save()
            
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            updateMoney()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == data.count {
            
            let selected = currencyPickerView.selectedRow(inComponent: 0)
            
            if selected == 0 {
                lblTotalMoney.text = "\(NSLocalizedString("lblTotalMoney", comment: "")): \(self.finalMoney)$"
            } else {
                
                let rate = currencys[selected-1].exchangeRate
                lblTotalMoney.text = "\(NSLocalizedString("lblTotalMoney", comment: "")): \(self.finalMoney * rate)\(currencys[selected-1].type!)"
            }
        }
    }
    
    // MARK: *** UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencys.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "USD"
        } else {
            return currencys[row-1].type
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            lblTotalMoney.text = "\(NSLocalizedString("lblTotalMoney", comment: "")): \(self.finalMoney)$"
            txtTypeCurrency.text = "USD"
        } else {
            let rate = currencys[row-1].exchangeRate
            lblTotalMoney.text = "\(NSLocalizedString("lblTotalMoney", comment: "")): \(self.finalMoney * rate)\(currencys[row-1].type!)"
            txtTypeCurrency.text = currencys[row-1].type!
        }
        
        self.view.endEditing(true)
    }
    
    // MARK: *** OrderControllerDelegate
    func doneEdit() {
        
        updateMoney()
    }
    
    func doneOrder() {
        
        self.finalMoney = 0.0
        data.removeAll()
        
        foods = table?.toFoods?.allObjects as! [Food]
        
        for food in foods {
            let listorderFood = food.toOrders?.allObjects as! [Order]
            let listorderTable = table?.toOrders?.allObjects as! [Order]
            
            for order in listorderFood {
                if let _ = listorderTable.index(of: order) {
                    let orderNewFood = orderFood(food: food, order: order)
                    data.append(orderNewFood)
                }
            }
        }
        
        tableView.reloadData()
        
    }
    
    // MARK: *** update money
    func updateMoney() {
        
        self.finalMoney = 0.0

        for i in 0..<self.tableView.numberOfSections {
            for j in 0..<self.tableView.numberOfRows(inSection: i) {
                
                if let cell = self.tableView.cellForRow(at: NSIndexPath(row: j, section: i) as IndexPath) as? HomeTableCell {
                    
                    let updateOrder = data[j].order
                    updateOrder.number = Int16(cell.number)
                    
                    self.finalMoney += (Double(cell.number) * cell.price)
                    
                    DB.save()
                }
            }
        }
        
        let selected = currencyPickerView.selectedRow(inComponent: 0)
        
        if selected == 0 {
            lblTotalMoney.text = "\(NSLocalizedString("lblTotalMoney", comment: "")): \(self.finalMoney)$"
        } else {
            let rate = currencys[selected-1].exchangeRate
            lblTotalMoney.text = "\(NSLocalizedString("lblTotalMoney", comment: "")): \(self.finalMoney * rate)\(currencys[selected-1].type!)"
        }
        
    }

}
