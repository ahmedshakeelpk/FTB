//
//  Sparrowindex.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 30/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct sparrowindexmodel : Mappable {
    var response : Int?
    var message : String?
    var datasparow : DataSparowindex?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        datasparow <- map["data"]
    }

}
struct DataSparowindex : Mappable {
    var customer_cnic : String?
    var customer_mobile : String?
    var customer_account_no : String?
    var customer_account_iban : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        customer_cnic <- map["customer_cnic"]
        customer_mobile <- map["customer_mobile"]
        customer_account_no <- map["customer_account_no"]
        customer_account_iban <- map["customer_account_iban"]
    }

}
