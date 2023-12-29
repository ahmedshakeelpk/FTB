//
//  TitleFetchTransactiinByAlias.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 31/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct TransationByAliasModel : Mappable {
    var response : Int?
    var message : String?
    var transaction : TitleFetchdata?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        transaction <- map["data"]
    }
   
}
struct TitleFetchdata : Mappable {
    var iban : String?
    var memberId : String?
    var accountTitle : String?
    var toAliasValue : String?
    var fromAliasValue : String?
    var fromAccounttitle : String?
    var fromAccountIban : String?
    var unique_unique_key : String?
    var toBankName : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        iban <- map["iban"]
        memberId <- map["memberId"]
        accountTitle <- map["accountTitle"]
        toAliasValue <- map["toAliasValue"]
        fromAliasValue <- map["fromAliasValue"]
        fromAccounttitle <- map["fromAccounttitle"]
        fromAccountIban <- map["fromAccountIban"]
        unique_unique_key <- map["unique_key"]
        toBankName <- map["toBankName"]
    }

}
