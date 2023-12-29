//
//  FurtherLoanInfoTableViewCell.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 01/08/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class FurtherLoanInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblInstallementDueDate: UILabel!
    @IBOutlet weak var lblActualInstallement: UILabel!
    @IBOutlet weak var lblPaidDate: UILabel!

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
