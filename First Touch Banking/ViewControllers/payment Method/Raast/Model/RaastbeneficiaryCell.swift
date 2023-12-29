//
//  RaastbeneficiaryCell.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 26/01/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit

class RaastbeneficiaryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var btndelete: UIButton!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    
}
