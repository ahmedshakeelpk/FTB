//
//  DebitCardActivation.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 28/03/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct DebitCardModel : Mappable {
    var response : Int?
    var message : String?
    var datadebit : DataModel?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        datadebit <- map["data"]
    }

}
struct DataModel : Mappable {
    var accountDebitCard : AccountDebitCard?
    var cardchannels : [Cardchannels]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accountDebitCard <- map["accountDebitCard"]
        cardchannels <- map["cardchannels"]
    }

}
struct Cardchannels : Mappable {
    var acquiringInterface : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        acquiringInterface <- map["acquiringInterface"]
        status <- map["status"]
    }

}
struct AccountDebitCard : Mappable {
    var account_no : String?
    var pan : String?
    var card_id : String?
    var debit_card_title : String?
    var card_type : String?
    var status : String?
    var card_expiry_year : String?
    var card_expiry_month : String?
    var debit_card_id : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        account_no <- map["account_no"]
        pan <- map["pan"]
        card_id <- map["card_id"]
        debit_card_title <- map["debit_card_title"]
        card_type <- map["card_type"]
        status <- map["status"]
        card_expiry_year <- map["card_expiry_year"]
        card_expiry_month <- map["card_expiry_month"]
        debit_card_id <- map["debit_card_id"]
    }

}
