//
//  MiniStatement.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 13/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class MiniStatement: Mappable {
    
    var ministatement: [SingleMiniStatement]?
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        ministatement <- map["data"]

    }
}


class SingleMiniStatement : Mappable {
    
    var trn_code : String?
    var trn_des : String?
    var lcy_amount : String?
    var drcr_ind : String?
    var value_dt : String?
    var trn_dt : String?
   
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        trn_code <- map["trn_code"]
        trn_des <- map ["trn_des"]
        lcy_amount <- map ["lcy_amount"]
        drcr_ind <- map ["drcr_ind"]
        value_dt <- map ["value_dt"]
        trn_dt <- map ["trn_dt"]
        
    }
}




