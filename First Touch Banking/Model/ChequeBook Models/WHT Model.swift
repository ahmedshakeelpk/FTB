//
//  WHT Model.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

struct WHTCalculations : Mappable {
    var response : Int?
    var message : String?
    var dataCalulations : [Dataa]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        dataCalulations <- map["data"]
    }
    

}
////struct WHTData : Mappable {
////    var cnic : String?
////    var customer_name : String?
////    var ac_branch : String?
////    var ac_no : String?
////    var wht_profit : Double?
////    var wht_cash : Int?
////    var wht_transfer : Int?
////
////    init?(map: Map) {
////
////    }
////
////    mutating func mapping(map: Map) {
////
////        cnic <- map["cnic"]
////        customer_name <- map["customer_name"]
////        ac_branch <- map["ac_branch"]
////        ac_no <- map["ac_no"]
////        wht_profit <- map["wht_profit"]
////        wht_cash <- map["wht_cash"]
////        wht_transfer <- map["wht_transfer"]
////    }
////
////}
////
////
//
//
//
struct Dataa : Mappable {
    var cnic : String?
    var customer_name : String?
    var ac_branch : String?
    var ac_no : String?
    var wht_profit : Double?
    var wht_cash : Int?
    var wht_transfer : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        cnic <- map["cnic"]
        customer_name <- map["customer_name"]
        ac_branch <- map["ac_branch"]
        ac_no <- map["ac_no"]
        wht_profit <- map["wht_profit"]
        wht_cash <- map["wht_cash"]
        wht_transfer <- map["wht_transfer"]
    }

}
//struct WHTaxModel: Codable {
//    let response: Int
//    let message: String
//    let data: [Datum]
//}
//
//// MARK: - Datum
//struct Datum: Codable {
//    let cnic, customerName, acBranch, acNo: String
//    let whtProfit: Double
//    let whtCash, whtTransfer: Int
//
//    enum CodingKeys: String, CodingKey {
//        case cnic
//        case customerName = "customer_name"
//        case acBranch = "ac_branch"
//        case acNo = "ac_no"
//        case whtProfit = "wht_profit"
//        case whtCash = "wht_cash"
//        case whtTransfer = "wht_transfer"
//    }
//}
