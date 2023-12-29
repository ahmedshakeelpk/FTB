//
//  Cell_showQr.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 17/08/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit

class Cell_showQr: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var qrview: UIView!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var img_Qr: UIImageView!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Amount: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Download: UIButton!
    @IBAction func share(_ sender: UIButton) {
        
        
    }
    
}
