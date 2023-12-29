//
//  BankNames.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 14/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

class BankNames: Mappable {
    
    var singleBank: [SingleBank]?
    var response: Int?
    var message:String?
    var stringBanks = [String]()
  
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        singleBank <- map["data"]
        
        for aBank in self.singleBank! {
            stringBanks.append(aBank.name!)
            
        }
        
        
    }
}


class SingleBank : Mappable {
    
    var name : String?
    var code : String?
    var description : String?
    var format:String?
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        name <- map["name"]
        code <- map ["code"]
        description <- map ["description"]
        format <- map ["format"]
         
        
    }
}
