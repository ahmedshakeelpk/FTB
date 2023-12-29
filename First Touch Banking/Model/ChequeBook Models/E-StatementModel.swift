//
//  E-StatementModel.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

//struct EStatment: Mappable {
//    var response : Int?
//    var message : String?
//    var Edata : [E_Stat]?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        response <- map["response"]
//        message <- map["message"]
//        Edata <- map["data"]
//    }
//
//}
//
//struct E_Stat : Mappable {
//    var trn_code : String?
//    var lcy_amount : String?
//    var drcr_ind : String?
//    var trn_dt : String?
//    var value_dt : String?
//    var txn_init_date : String?
//    var amount_tag : String?
//    var txn_dt_time : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        trn_code <- map["trn_code"]
//        lcy_amount <- map["lcy_amount"]
//        drcr_ind <- map["drcr_ind"]
//        trn_dt <- map["trn_dt"]
//        value_dt <- map["value_dt"]
//        txn_init_date <- map["txn_init_date"]
//        amount_tag <- map["amount_tag"]
//        txn_dt_time <- map["txn_dt_time"]
//    }
//
//}

struct EStatment : Mappable {
    var response : Int?
    var message : String?
    var data : [E_Stat]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        data <- map["data"]
    }

}
struct E_Stat : Mappable {
    var trn_code : String?
    var lcy_amount : String?
    var drcr_ind : String?
    var value_dt : String?
    var trn_dt : String?
    var txn_init_date : String?
    var amount_tag : String?
    var txn_dt_time : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        trn_code <- map["trn_code"]
        lcy_amount <- map["lcy_amount"]
        drcr_ind <- map["drcr_ind"]
        value_dt <- map["value_dt"]
        trn_dt <- map["trn_dt"]
        txn_init_date <- map["txn_init_date"]
        amount_tag <- map["amount_tag"]
        txn_dt_time <- map["txn_dt_time"]
    }

}
