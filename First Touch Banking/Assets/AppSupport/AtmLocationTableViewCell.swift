//
//  AtmLocationTableViewCell.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 12/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class AtmLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAtmTitle: UILabel!
    @IBOutlet weak var lblAtmAddress: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
