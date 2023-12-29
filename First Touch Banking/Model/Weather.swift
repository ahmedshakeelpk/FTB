//
//  Weather.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 15/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

class Weather: Mappable {
    
    var wx_desc:String?
    var temp_c:Int?

    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        wx_desc <- map["wx_desc"]
        temp_c <- map["temp_c"]
    }
}
