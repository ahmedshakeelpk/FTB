//
//  MoviesBookingTableViewCell.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class MoviesBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblCinemaName: UILabel!
    @IBOutlet weak var lblShowDate: UILabel!
    @IBOutlet weak var lblTicketPrice: UILabel!
    @IBOutlet var btn_Book: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
