//
//  FoodCell.swift
//  1542257-1542258
//
//  Created by Phu on 4/11/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {
    
    // MARK: *** UI Elements
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var txtNameFood: UILabel!
    @IBOutlet weak var txtDescriptionFood: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
