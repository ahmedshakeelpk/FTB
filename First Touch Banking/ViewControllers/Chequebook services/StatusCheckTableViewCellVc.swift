//
//  StatusCheckTableViewCellVc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class StatusCheckTableViewCellVc: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCheckLeaves: UILabel!
    @IBOutlet weak var lblLeavesValue: UILabel!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lblStatusValue: UILabel!
    @IBOutlet weak var lblAccNOValue: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    
    
    
    
    
    
}
