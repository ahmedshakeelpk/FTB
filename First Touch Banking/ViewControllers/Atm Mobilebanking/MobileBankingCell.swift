//
//  MobileBankingCell.swift
//  First Pay
//
//  Created by Arsalan Amjad on 23/12/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class MobileBankingCell: UITableViewCell {
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
   
    @IBOutlet weak var btnchangelimit: UIButton!
    
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var lblTransactionname: UILabel!
    @IBOutlet weak var backview: UIView!
    
    
}
