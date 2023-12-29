//
//  MyLoanTableViewCell.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 30/07/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class MyLoanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblproductName: UILabel!
    @IBOutlet weak var lbldisburtionDate: UILabel!
    @IBOutlet weak var lblamountFinanced: UILabel!
    @IBOutlet weak var lbloutstandingAmount: UILabel!
    @IBOutlet weak var lblLoanStatus: UILabel!

    @IBOutlet weak var backview: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
