//
//  UtilityBillCollectionViewCell.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 09/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class UtilityBillCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var title : UILabel!
    @IBOutlet weak var viewForImage: UIView!
    
    
    private func updateButtonsRadius(){
        self.imageView.layer.cornerRadius = self.imageView.bounds.height / 2
    }
}
