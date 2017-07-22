//
//  CounterCell.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class CounterCell: UITableViewCell {

    // MARK: *** UI Elements
    @IBOutlet weak var imageCounter: UIImageView!
    @IBOutlet weak var lblCounterName: UILabel!
    @IBOutlet weak var lblCounterDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
