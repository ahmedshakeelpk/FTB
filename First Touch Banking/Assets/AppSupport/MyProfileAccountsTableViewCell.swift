//
//  MyProfileAccountsTableViewCell.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 27/06/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class MyProfileAccountsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblAccountType: UILabel!

    @IBOutlet weak var lblIBAN: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
