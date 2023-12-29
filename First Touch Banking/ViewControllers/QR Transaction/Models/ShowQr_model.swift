//
//  ShowQr_model.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 17/08/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import ObjectMapper

struct SowQr_Model : Mappable {
    var response : Int?
    var message : String?
    var dataQr : [ShowQRdata]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        dataQr <- map["data"]
    }

}
struct ShowQRdata : Mappable {
    var id : Int?
    var point_of_initiation : String?
    var name : String?
    var iban : String?
    var amount : String?
    var expiry_date : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        point_of_initiation <- map["point_of_initiation"]
        name <- map["name"]
        iban <- map["iban"]
        amount <- map["amount"]
        expiry_date <- map["expiry_date"]
    }

}
