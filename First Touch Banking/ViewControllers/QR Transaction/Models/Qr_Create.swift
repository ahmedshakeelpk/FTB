//
//  Qr_Create.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 17/08/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper
struct Create_QR : Mappable {
    var response : Int?
    var message : String?
    var datas : CreationQr?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        datas <- map["data"]
    }

}


struct CreationQr : Mappable {
    var payload_format : Int?
    var point_of_initiation : Int?
    var scheme_identifier : Int?
    var crc : Int?
    var iban : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        payload_format <- map["payload_format"]
        point_of_initiation <- map["point_of_initiation"]
        scheme_identifier <- map["scheme_identifier"]
        crc <- map["crc"]
        iban <- map["iban"]
    }

}
