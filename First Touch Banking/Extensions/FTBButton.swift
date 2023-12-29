//
//  FTBButton.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
class FTBButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.bounds.height/2
        self.titleLabel?.textColor = UIColor(hexString: "#0079B8")
    }
}
