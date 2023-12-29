//
//  QuickPay.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 27/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class QuickPay: Mappable {
    
    var beneficiaries: [SingleBeneficiary]?
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        beneficiaries <- map["data"]
        
        
    }
}


class SingleBeneficiary : Mappable {
    
    var id : Int?
    var name : String?
    var account : String?
    var beneficiary_company : String?
    var beneficiary_code : String?
    var beneficiary_type : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        id <- map["id"]
        name <- map ["name"]
        account <- map ["account"]
        beneficiary_company <- map ["beneficiary_company"]
        beneficiary_code <- map ["beneficiary_code"]
        beneficiary_type <- map ["beneficiary_type"]
        
        
    }
}
