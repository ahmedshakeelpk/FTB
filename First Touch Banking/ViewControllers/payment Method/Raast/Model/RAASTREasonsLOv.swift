//
//  RAASTREasonsLOv.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 10/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper
struct RaastReason: Mappable {
    
//    var singleReason: [SingleReason]?
    var response: Int?
    var message:String?
    var stringReasons = [String]()
    var singleReason : [List]?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

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



struct List : Mappable {
    
    var code : String?
    var description : String?
  
    init?(map: Map){ }
    
    mutating func mapping(map: Map){

        code <- map ["code"]
        description <- map ["description"]
        
    }
}

