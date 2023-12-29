//
//  BillPaymentCompanies.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 09/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class BillPaymentCompanies: Mappable {
    
    var companies: [SingleCompany]?
    var response: Int?
    var message:String?

    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        companies <- map["data"]
        
    }
}


class SingleCompany : Mappable {
    
    var name : String?
    var code : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        name <- map ["name"]
        code <- map ["code"]
        
        
    }
}
