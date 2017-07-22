//
//  StatisticalVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

class StatisticalVC: UIViewController, AKRadioButtonsControllerDelegate {

    // MARK: UI Elements
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet var radioButtons: [AKRadioButton]!
    @IBOutlet var radioButtonsTime: [AKRadioButton]!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtMonTh: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var lblTypeStatistical: UILabel!
    @IBOutlet weak var lblChooseTime: UILabel!
    @IBOutlet weak var btnStatistical: UIButton!
    
    let dateFormatter = DateFormatter()
    let monthFormatter = DateFormatter()
    
    let pickerDate = UIDatePicker()
    let pickerMonth = UIDatePicker()
    let pickerDateStart = UIDatePicker()
    let pickerDateEnd = UIDatePicker()
    
    // MARK: *** UI Events
    @IBAction func btnStatistical_Tapped(_ sender: UIButton) {
        
        if radioButtonController.selectedIndex == 0 {
            
            if radioButtonControllerTime.selectedIndex == 0 {
                
                performSegue(withIdentifier: "StatisticalRevenuebyDateID", sender: self)
            } else if radioButtonControllerTime.selectedIndex == 1 {
                
                performSegue(withIdentifier: "StatisticalRevenuebyMonthID", sender: self)
            } else if radioButtonControllerTime.selectedIndex == 2 {
                
                performSegue(withIdentifier: "StatisticalRevenuebyPriodID", sender: self)
            }
        } else if radioButtonController.selectedIndex == 1 {
            
            if radioButtonControllerTime.selectedIndex == 0  {
                
                performSegue(withIdentifier: "StatisticalQuantityByDateID", sender: self)
            } else if radioButtonControllerTime.selectedIndex == 1 {
                
                performSegue(withIdentifier: "StatisticalQuantityByMonthID", sender: self)
            } else if radioButtonControllerTime.selectedIndex == 2 {
                
                performSegue(withIdentifier: "StatisticalQuantityByPriodID", sender: "")
            }
        }
        
    }
    
    
    // MARK: *** Data model
    var radioButtonController: AKRadioButtonsController!
    var radioButtonControllerTime: AKRadioButtonsController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("menu_statistical", comment: "")
        
        if revealViewController() != nil {
            btnMenu.target = revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        lblTypeStatistical.text = NSLocalizedString("selectTypeStatistical", comment: "")
        lblChooseTime.text = NSLocalizedString("chooseTime", comment: "")
        
        radioButtons[0].setTitle(NSLocalizedString("radioRevenue", comment: ""), for: .normal)
        radioButtons[1].setTitle(NSLocalizedString("radioQuantity", comment: ""), for: .normal)
        
        radioButtonsTime[0].setTitle(NSLocalizedString("lblDate", comment: ""), for: .normal)
        radioButtonsTime[1].setTitle(NSLocalizedString("lblMonth", comment: ""), for: .normal)
        radioButtonsTime[2].setTitle(NSLocalizedString("choosePeriodOftime", comment: ""), for: .normal)
        btnStatistical.setTitle(NSLocalizedString("menu_statistical", comment: ""), for: .normal)
        
        self.radioButtonController = AKRadioButtonsController(radioButtons: self.radioButtons)
        self.radioButtonController.delegate = self
        
        self.radioButtonControllerTime = AKRadioButtonsController(radioButtons: self.radioButtonsTime)
        self.radioButtonControllerTime.delegate = self
        
        txtMonTh.isEnabled = false
        txtStartDate.isEnabled = false
        txtEndDate.isEnabled = false
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtDate.text = dateFormatter.string(from: Date())
        
        monthFormatter.dateFormat = "MM/yyyy"
        txtMonTh.text = monthFormatter.string(from: Date())
        
        txtStartDate.text = dateFormatter.string(from: Date())
        txtEndDate.text = dateFormatter.string(from: Date())
        
        createDatePicker(picker: pickerDate, textField: txtDate)
        createDatePicker(picker: pickerMonth, textField: txtMonTh)
        createDatePicker(picker: pickerDateStart, textField: txtStartDate)
        createDatePicker(picker: pickerDateEnd, textField: txtEndDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StatisticalRevenuebyDateID" {
            let dest = segue.destination as! RevenueByDateVC
            dest.date = pickerDate.date
        } else if segue.identifier == "StatisticalRevenuebyMonthID" {
            let dest = segue.destination as! RevenueByMonthVC
            dest.month = pickerMonth.date
        } else if segue.identifier == "StatisticalRevenuebyPriodID" {
            let dest = segue.destination as! RevenueByPriodVC
            dest.fromDate = pickerDateStart.date
            dest.toDate = pickerDateEnd.date
        } else if segue.identifier == "StatisticalQuantityByDateID" {
            let dest = segue.destination as! QuantityByDateVC
            dest.date = pickerDate.date
        } else if segue.identifier == "StatisticalQuantityByMonthID" {
            let dest = segue.destination as! QuantityByMonthVC
            dest.month = pickerMonth.date
        } else if segue.identifier == "StatisticalQuantityByPriodID" {
            let dest = segue.destination as! QuantityByPriodVC
            dest.fromDate = pickerDateStart.date
            dest.toDate = pickerDateStart.date
        }
    }
    
    func selectedButton(sender: AKRadioButton){
        if radioButtonControllerTime.selectedIndex == 0 {
            txtDate.isEnabled = true
            txtMonTh.isEnabled = false
            txtStartDate.isEnabled = false
            txtEndDate.isEnabled = false
        } else if radioButtonControllerTime.selectedIndex == 1 {
            txtDate.isEnabled = false
            txtMonTh.isEnabled = true
            txtStartDate.isEnabled = false
            txtEndDate.isEnabled = false
        } else if radioButtonControllerTime.selectedIndex == 2 {
            txtDate.isEnabled = false
            txtMonTh.isEnabled = false
            txtStartDate.isEnabled = true
            txtEndDate.isEnabled = true
        }
    }
    
    // Tao DatePicker
    func createDatePicker(picker: UIDatePicker, textField: UITextField) {
        
        // format for picker
        if picker == pickerMonth {
            
        }
        picker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: NSLocalizedString("done", comment: ""), style: .done, target: nil, action: #selector(donePressed))
        ]
        
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
        textField.inputView = picker
    }
    
    func donePressed() {
        txtDate.text = dateFormatter.string(from: pickerDate.date)
        txtMonTh.text = monthFormatter.string(from: pickerMonth.date)
        txtStartDate.text = dateFormatter.string(from: pickerDateStart.date)
        txtEndDate.text = dateFormatter.string(from: pickerDateEnd.date)
        self.view.endEditing(true)
    }



}
