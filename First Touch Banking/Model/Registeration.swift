//
//  Registeration.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 07/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper




struct Registeration: Mappable {
    
//    var response: Int?
//    var message:String?
//    var cid: String?
//    var otp: String?
//
//    var mobile_number: String?
//    var cnic: String?
//    var account: String?
//    var token: String?
//
//
//
//    required init?(map: Map){ }
//
//
//    func mapping(map: Map) {
//        response <- map["response"]
//        message <- map["message"]
//        cid <- map["data.cid"]
//        otp <- map["data.otp"]
//        token <- map["data.token"]
//
//        mobile_number <- map["message.mobile_number"]
//        cnic <- map["message.cnic"]
//        account <- map ["message.account"]
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
        var cid : Int?
        var otp : Int?
        var token : String?
        var step : String?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            cid <- map["cid"]
            otp <- map["otp"]
            token <- map["token"]
            step <- map["step"]
        }

    }

    
    
    
    
    
}
