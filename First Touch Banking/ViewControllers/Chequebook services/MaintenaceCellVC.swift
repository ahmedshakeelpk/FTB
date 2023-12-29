//
//  MaintenaceCellVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class MaintenaceCellVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBOutlet weak var lblAccNo: UILabel!
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblAccNovalue: UILabel!
    @IBOutlet weak var lblOpeningDate: UILabel!
    @IBOutlet weak var lblAccTitleValue: UILabel!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lblStatusValue: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblBranchNameValue: UILabel!
    @IBOutlet weak var lblBranchName: UILabel!
    @IBOutlet weak var lblOpeningDateValue: UILabel!
}
