//
//  ChooseFoodCell.swift
//  1542257-1542258
//
//  Created by Phu on 4/17/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class ChooseFoodCell: UITableViewCell {
    
    // MARK: *** UI Elements
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var lblNameFood: UILabel!
    @IBOutlet weak var lblPriceFood: UILabel!
    @IBOutlet weak var txtNumberFood: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
