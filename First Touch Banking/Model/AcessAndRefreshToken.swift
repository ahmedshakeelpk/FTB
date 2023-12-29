//
//  AcessAndRefreshToken.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 08/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

struct AcessAndRefreshToken : Mappable {
    var response : Int?
    var message : String?
    var data : AcessAndRefreshToken1?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        data <- map["data"]
    }

}
struct AcessAndRefreshToken1: Mappable {
    
    var token_type : String?
    var expires_in : Int?
    var access_token : String?
    var refresh_token : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        token_type <- map["token_type"]
        expires_in <- map["expires_in"]
        access_token <- map["access_token"]
        refresh_token <- map["refresh_token"]
    }
    
}
