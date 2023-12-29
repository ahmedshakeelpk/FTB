//
//  LocalFundsTransfer.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 13/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class  LocalFundsTransfer: Mappable {
    
    var response: Int?
    var message:String?
    var account_number:String?
    var stan:String?
    var host_response:String?
    var tran_time:String?

    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        account_number <- map["data.account_number"]
        stan <- map["data.stan"]
        host_response <- map["data.host_response"]
        tran_time <- map["data.tran_time"]
        
    }
}

/*
 {
 "response": 1,
 "message": "Your transaction has been successfully completed.",
 "data": {
 "account_number": "0021011133005012",
 "stan": "852074",
 "host_response": "00",
 "tran_time": "2017-12-14 11:45:33"
 }
 }
 
 */
