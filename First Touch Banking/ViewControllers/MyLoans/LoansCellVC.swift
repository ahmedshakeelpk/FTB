//
//  LoansCellVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 16/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit

class LoansCellVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var actuallIns: UILabel!
    
    @IBOutlet weak var PaidAmount: UILabel!
    @IBOutlet weak var installmentDueDate: UILabel!
    @IBOutlet weak var PaidDate: UILabel!
    
    
    
    
    
}
