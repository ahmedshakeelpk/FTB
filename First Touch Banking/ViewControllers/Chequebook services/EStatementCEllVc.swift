//
//  EStatementCEllVc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class EStatementCEllVc: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }

    
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lbllcyamount: UILabel!
    @IBOutlet weak var lbldateplusdrcrind: UILabel!
    @IBOutlet weak var lblamounttag: UILabel!
    
}
