//
//  GetReaons.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 09/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

class GetReaons: Mappable {
    
    var singleReason: [SingleReason]?
    var response: Int?
    var message:String?
    var stringReasons = [String]()
    
    
    required init?(map: Map){ }
    
   
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        singleReason <- map["data"]
        
        if let singleReasons = self.singleReason{
            for aReason in singleReasons {
                stringReasons.append(aReason.description!)
            }
        }
        
        
    }
}


class SingleReason : Mappable {
    
    var code : String?
    var description : String?
  
    required init?(map: Map){ }
    
    func mapping(map: Map){

        code <- map ["code"]
        description <- map ["description"]
        
    }
}
