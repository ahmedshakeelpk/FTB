//
//  TitleFetch.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 13/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class  TitleFetch: Mappable {
    
    var response: Int?
    var message:String?
    var account_title:String?
    var account_number:String?
    var stan:String?
    var benificiary_iban:String?
    var otp_id:Int?

    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        response <- map["response"]
        message <- map["message"]
        account_title <- map["data.account_title"]
        account_number <- map["data.account_number"]
        stan <- map["data.stan"]
        benificiary_iban <- map["data.benificiary_iban"]
        otp_id <- map["data.otp_id"]

    }
}


