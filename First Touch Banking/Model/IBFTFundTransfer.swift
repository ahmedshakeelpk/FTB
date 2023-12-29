//
//  IBFTFundTransfer.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 14/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class  IBFTFundTransfer: Mappable {
    
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
