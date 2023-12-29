//
//  FTBView.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

@IBDesignable class FTBView: UIView {
    
    // 1. Set up your enum
    public enum ViewType: Int {
        case unspecified = 0
        case rounded = 1
        case circle = 2
    }
    
    // Programmatically: use the enum
    var type:ViewType = .unspecified
    
    @IBInspectable var viewType: Int {
        get {
        return self.type.rawValue
        }
        set( shapeIndex) {
        self.type = ViewType(rawValue: shapeIndex) ?? .unspecified
        loadRoundedCornor()
        
        }
//        didSet {
//            loadRoundedCornor()
//        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadRoundedCornor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadRoundedCornor()
    }
    
    func loadRoundedCornor() {
        
        if viewType == ViewType.rounded.rawValue {
            self.layer.cornerRadius = 4
        } else if viewType == ViewType.circle.rawValue {
            self.layer.cornerRadius = self.bounds.height / 2
        } else {
            self.layer.cornerRadius = 4
        }
    }
}
