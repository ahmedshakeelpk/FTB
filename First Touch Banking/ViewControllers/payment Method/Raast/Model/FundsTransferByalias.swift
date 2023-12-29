//
//  FundsTransferByalias.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 31/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct FundTransfer : Mappable {
    var response : Int?
    var message : String?
    var datatransfer : transferfund?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        datatransfer <- map["data"]
    }

}

struct transferfund : Mappable {
    var from_account : String?
    var from_account_number : String?
    var from_account_title : String?
    var to_account : String?
    var to_account_number : String?
    var to_account_title : String?
    var amount : String?
    var stan : String?
    var host_response : String?
    var trx_time : String?
    var transaction_id : Int?
    var toBankName : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        from_account <- map["from_account"]
        from_account_number <- map["from_account_number"]
        from_account_title <- map["from_account_title"]
        to_account <- map["to_account"]
        to_account_number <- map["to_account_number"]
        to_account_title <- map["to_account_title"]
        amount <- map["amount"]
        stan <- map["stan"]
        host_response <- map["host_response"]
        trx_time <- map["trx_time"]
        transaction_id <- map["transaction_id"]
        toBankName <- map ["toBankName"]
    }

}
