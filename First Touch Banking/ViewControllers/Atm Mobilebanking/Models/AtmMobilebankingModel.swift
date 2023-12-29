//
//  AtmMobilebankingModel.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 03/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct AtmMobilebankingModel : Mappable {
    var response : Int?
    var message : String?
    var data : AtmBanking?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        data <- map["data"]
    }

}
struct AtmBanking : Mappable {
    var mB : [MB]?
    var aTM : [ATM]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        mB <- map["MB"]
        aTM <- map["ATM"]
    }

}
struct ATM : Mappable {
    var identifier : String?
    var key : String?
    var limitID : String?
    var limitAmount : String?
    var frequency : String?
    var channelCode : String?
    var channelName : String?
    var transactionName : String?
    var maximumAllowedLimit : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        identifier <- map["identifier"]
        key <- map["key"]
        limitID <- map["limitID"]
        limitAmount <- map["limitAmount"]
        frequency <- map["frequency"]
        channelCode <- map["channelCode"]
        channelName <- map["channelName"]
        transactionName <- map["transactionName"]
        maximumAllowedLimit <- map["maximumAllowedLimit"]
    }

}
struct MB : Mappable {
    var identifier : String?
    var key : String?
    var limitID : String?
    var limitAmount : String?
    var frequency : String?
    var channelCode : String?
    var channelName : String?
    var transactionName : String?
    var maximumAllowedLimit : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        identifier <- map["identifier"]
        key <- map["key"]
        limitID <- map["limitID"]
        limitAmount <- map["limitAmount"]
        frequency <- map["frequency"]
        channelCode <- map["channelCode"]
        channelName <- map["channelName"]
        transactionName <- map["transactionName"]
        maximumAllowedLimit <- map["maximumAllowedLimit"]
    }

}
