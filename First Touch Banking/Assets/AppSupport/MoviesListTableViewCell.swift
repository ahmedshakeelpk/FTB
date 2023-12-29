//
//  MoviesListTableViewCell.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 18/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class MoviesListTableViewCell: UITableViewCell {


    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieGenre: UILabel!
    @IBOutlet weak var lblLength: UILabel!
    @IBOutlet weak var imgMovieThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
