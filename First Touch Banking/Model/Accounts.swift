//
//  Accounts.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 13/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

class Accounts: Mappable {
    
    var singleAccount: [SingleAccount]?
    var response: Int?
    var message:String?
    var stringAccounts = [String]()

    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        singleAccount <- map["data"]
        
        for aAccount in self.singleAccount ?? [] {
            stringAccounts.append(aAccount.account_number!)
        }
        
    }
}


class SingleAccount : Mappable {
    
    var account_number : String?
    var type : String?

    
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        account_number <- map["account_number"]
        type <- map ["type"]

    }
}

/*
 {
 "response": 1,
 "message": "Authorize",
 "data": [
 {
 "account_number": "0021011133005012",
 "type": "primary"
 }
 ]
 }
 */
