//
//  TitleBalanceStatementModel.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 24/09/2019.
//  Copyright © 2019 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class  TitleBalanceStatementModel: Mappable {
    
    var response: Int?
    var message:String?
    var account_title:String?
    var account_number:String?
    var benificiary_iban:String?
    var otp_id:Int?
    var account_curr_balance:String?
    var account_balance:String?
    var stan:String?
    
    var trn_code:String?
    var trn_des:String?
    var lcy_amount:String?
    var drcr_ind:String?
    var value_dt:String?
    var trn_dt:String?
    var trn_stan:String?

    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        response <- map["response"]
        message <- map["message"]
        account_title <- map["data.title.account_title"]
        benificiary_iban <- map["data.title.benificiary_iban"]
        account_number <- map["data.title.account_number"]
        stan <- map["data.title.stan"]
        otp_id <- map["data.title.otp_id"]
        account_number <- map["data.balance.account_number"]
        stan <- map["data.balance.stan"]
        account_curr_balance <- map["data.balance.account_curr_balance"]
        account_balance <- map["data.balance.account_balance"]
        trn_code <- map["data.statement.trn_code"]
        trn_des <- map["data.statement.trn_des"]
        lcy_amount <- map["data.statement.lcy_amount"]
        drcr_ind <- map["data.statement.drcr_ind"]
        value_dt <- map["data.statement.value_dt"]
        trn_dt <- map["data.statement.trn_dt"]
        trn_stan <- map["data.statement.trn_stan"]
        
        
        
        
        

    }
}
