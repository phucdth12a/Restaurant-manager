//
//  QuantityByMonthCell.swift
//  1542257-1542258
//
//  Created by Phu on 4/21/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class QuantityByMonthCell: UITableViewCell {
    
    // MARK: *** UI Elements
    @IBOutlet weak var lblNameValue: UILabel!
    @IBOutlet weak var lblNumberValue: UILabel!
    @IBOutlet weak var lblNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
