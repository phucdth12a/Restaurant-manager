//
//  DetailCurrencyVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

class DetailCurrencyVC: UIViewController, UITextFieldDelegate {
    
    // MARK: *** Local variables
    var delegate: CurrencyControllerDelegate?
    
    // MARK: *** UI Elements
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtRate: UITextField!
    
    // MARK: *** Data model
    var model = ""
    var currency: Currency?
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButton(tos: [txtType, txtRate])
        
        lblType.text = NSLocalizedString("lblCurrency", comment: "")
        lblRate.text = NSLocalizedString("lblExchangeRate", comment: "")
        
        if model == "Add" {
            self.title = NSLocalizedString("titleAddCurrency", comment: "")
            let addButton = UIBarButtonItem(title: NSLocalizedString("btnAdd", comment: ""), style: .done, target: self, action: #selector(addCurrency_Tapped))
            self.navigationItem.setRightBarButton(addButton, animated: true)
        } else if model == "Edit" {
            self.title = NSLocalizedString("titleEditCurrency", comment: "")
            let editButton = UIBarButtonItem(title: NSLocalizedString("btnEdit", comment: ""), style: .done
                , target: self, action: #selector(editCurrency_Tapped))
            self.navigationItem.setRightBarButton(editButton, animated: true)
            
            loadData()
        }
        
        self.txtRate.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }

    func addCurrency_Tapped() {
        if txtType.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_typeCurrency", comment: ""))
        } else if txtRate.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_rateCurrency", comment: ""))
        } else {
            
            let newcurrency = Currency.create() as! Currency
            newcurrency.type = txtType.text
            newcurrency.exchangeRate = Double(txtRate.text!)!
            
            DB.save()
            delegate?.addCurrency(newCurrency: newcurrency)
            alert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("success_addCurrency", comment: ""), handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            
        }
    }
    
    func editCurrency_Tapped() {
        if txtType.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_typeCurrency", comment: ""))
        } else if txtRate.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_rateCurrency", comment: ""))
        } else {
            currency?.type = txtType.text
            currency?.exchangeRate = Double(txtRate.text!)!

            DB.save()
            alert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("success_editCurrency",  comment: ""), handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func loadData() {
        txtType.text = currency?.type
        let rate: Double = (currency?.exchangeRate)!
        txtRate.text! = String(rate)
    }
}
