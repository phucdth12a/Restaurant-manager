//
//  HomeTableCell.swift
//  1542257-1542258
//
//  Created by Phu on 4/16/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {

    // MARK: *** UI Elements
    @IBOutlet weak var imageTable: UIImageView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblTotalMoney: UILabel!
    @IBOutlet weak var lblNameFood: UILabel!
    
    // MARK: *** Data model
    var number: Int = 0
    var price: Double = 0.0
    var delegate: OrderControllerDelegate?
    
    // MARK: UI Events
    @IBAction func btnMinus_Tapped(_ sender: UIButton) {
        if (number != 1) {
            number -= 1
            if number < 10 {
                lblNumber.text = "0\(number)"
            } else {
                lblNumber.text = "\(number)"
            }
            
            lblTotalMoney.text = "\((Double(number) * price))$"
            delegate?.doneEdit()
        }
    }
    
    @IBAction func btnPush_Tapped(_ sender: UIButton) {
        number += 1
        if number < 10 {
            lblNumber.text = "0\(number)"
        } else {
            lblNumber.text = "\(number)"
        }
        lblTotalMoney.text = "\((Double(number) * price))$"
        delegate?.doneEdit()
    }
    
    
    // MARK: *** UIViewController
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
