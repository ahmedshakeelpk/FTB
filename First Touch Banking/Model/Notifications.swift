//
//  Notifications.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 11/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import ObjectMapper


class Notifications: Mappable {
    
    var notifications: [SingleNotification]?
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        notifications <- map["data"]
        
        
    }
}


class SingleNotification : Mappable {
    
    var id : Int?
    var NotifMessage : String?
    var status : Int?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        id <- map["id"]
        NotifMessage <- map ["message"]
        status <- map ["status"]
        
        
    }
}
