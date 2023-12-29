//
//  TransactionConsent.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 22/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class  TransactionConsent: Mappable {
    
    var response: Int?
    var message:String?
    var consentTrans: [SingleAccountConsent]?

    
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        consentTrans <- map["data"]
       
    }
}

class SingleAccountConsent : Mappable {
    
    var account_number:String?
    var transaction_consents:Int?

    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        account_number <- map["account_number"]
        transaction_consents <- map["transaction_consents"]
    }
}
