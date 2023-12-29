//
//  AgentLocator.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 12/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class AgentLocator: Mappable {
    
    var agentLocators: [SingleAgentLocator]?
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        agentLocators <- map["data"]
        
        
    }
}


class SingleAgentLocator : Mappable {
    
    var id : Int?
    var code : String?
    var name : String?
    var address : String?
    var area : String?
    var lat : Double?
    var lng : Double?
    var contact_person : String?
    var landline : String?
    var type : String?
    var email : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        id <- map["id"]
        code <- map ["code"]
        name <- map ["name"]
        address <- map ["address"]
        area <- map ["area"]
        lat <- map ["lat"]
        lng <- map ["lng"]
        contact_person <- map ["contact_person"]
        landline <- map ["landline"]
        type <- map ["type"]
        email <- map ["email"]

    }
}
