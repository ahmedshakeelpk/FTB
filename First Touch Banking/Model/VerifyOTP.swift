//
//  VerifyOTP.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 07/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


struct VerifyOTP: Mappable {
    
    //    var response: Int?
    //    var message:String?
    //    var unique_key: String?
    //
    //    required init?(map: Map){ }
    //
    //    func mapping(map: Map) {
    //        response <- map["response"]
    //        message <- map["message"]
    //        unique_key <- map["data.unique_key"]
    //
    //
    //
    //
    //    }
    var response : Int?
    var message : String?
    var data : Data?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        data <- map["data"]
    }
    
    struct Data : Mappable {
        var unique_key : String?
        var step : String?
        
        init?(map: Map) {
            
        }
        mutating func mapping(map: Map) {
            
            unique_key <- map["unique_key"]
            step <- map["step"]
        }
        
    }
    
}
