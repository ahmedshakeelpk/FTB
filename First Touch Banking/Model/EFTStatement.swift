//
//  EFTStatement.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 10/01/2019.
//  Copyright © 2019 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class EFTStatement: Mappable {
    
    var eftStatement: [SingleEFTStatement]?
    var response: Int?
    var message:String?
    
    var account_number:String?
    var opening_balance:String?
    var closing_balance:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        eftStatement <- map["data.efo_list"]
        account_number <- map["data.account_number"]
        opening_balance <- map["data.opening_balance"]
        closing_balance <- map["data.closing_balance"]
        
    }
}

class SingleEFTStatement : Mappable {
    
    var dateOfEFT : String?
    var eftType : String?
    var eftChannel : String?
    var eftAmount : String?
    var eftFee : String?
    var originatorName : String?
    var originatorAFIName : String?
    
    
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        dateOfEFT <- map["dateOfEFT"]
        eftType <- map ["eftType"]
        eftChannel <- map ["eftChannel"]
        eftAmount <- map ["eftAmount"]
        eftFee <- map ["eftFee"]
        originatorName <- map ["originatorName"]
        originatorAFIName <- map ["originatorAFIName"]
    }
}
