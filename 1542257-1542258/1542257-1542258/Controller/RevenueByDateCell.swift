//
//  RevenueByDateCell.swift
//  1542257-1542258
//
//  Created by Phu on 4/18/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class RevenueByDateCell: UITableViewCell {
    
    // MARK: *** UI Elements
    @IBOutlet weak var imageTable: UIImageView!
    @IBOutlet weak var lblNameTable: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTien: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
