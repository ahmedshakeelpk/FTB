//
//  SparrowRegister.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 30/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct SparrowRegisterModel : Mappable {
    var response : Int?
    var message : String?
    var SparrowRegister : Register?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        SparrowRegister <- map["data"]
    }

}
struct Register : Mappable {
    var s_response : String?
    var s_alias_type : String?
    var customer_mobile : String?
    var s_alias_value : String?
    var s_iban : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        s_response <- map["s_response"]
        s_alias_type <- map["s_alias_type"]
        customer_mobile <- map["customer_mobile"]
        s_alias_value <- map["s_alias_value"]
        s_iban <- map["s_iban"]
    }

}
