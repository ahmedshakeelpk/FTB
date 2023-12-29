//
//  WHTCellvc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class WHTCellvc: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var lblCNIC: UILabel!
    
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var WHTProfitValue: UILabel!
    @IBOutlet weak var lblWHTProfit: UILabel!
    @IBOutlet weak var whtValue: UILabel!
    @IBOutlet weak var lblWHT: UILabel!
    @IBOutlet weak var AccNoValue: UILabel!
    @IBOutlet weak var lblAccNo: UILabel!
    @IBOutlet weak var customerNameValue: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCnicValue: UILabel!
}
