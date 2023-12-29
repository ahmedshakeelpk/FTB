//
//  NotificationPut.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 20/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class NotificationPut: Mappable {
    
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
    }
}
