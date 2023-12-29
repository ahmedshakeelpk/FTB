//
//  BalanceInquiry.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 08/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class BalanceInquiry: Mappable {
    
    var response: Int?
    var message:String?
    var account_curr_balance:String?
    var account_balance:String?
    var account_number:String?
    var stan:String?

    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        response <- map["response"]
        message <- map["message"]
        account_curr_balance <- map["data.account_curr_balance"]
        account_balance <- map["data.account_balance"]
        account_number <- map["data.account_number"]
        stan <- map["data.stan"]
        
    }
    
}


/*
 
 {
 "response": 1,
 "message": "Authorize",
 "data": {
 "account_curr_balance": "1.30",
 "account_balance": "1.30",
 "account_number": "0021011133005012",
 "stan": "852745"
 }
 }
 
 */
