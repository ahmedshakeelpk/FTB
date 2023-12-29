//
//  MyLoansModel.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 16/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct MyLoansDetail : Mappable {
    var response : Int?
    var message : String?
    var data : [Loans]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        data <- map["data"]
    }

}
struct Loans : Mappable {
    var account_number : String?
    var prod_code : String?
    var prod_name : String?
    var disb_date : String?
    var tenure : String?
    var frequency : String?
    var loan_status : String?
    var amount_financed : String?
    var outstanding_amount : String?
    var outstanding_markup : String?
    var guarantee_details : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        account_number <- map["account_number"]
        prod_code <- map["prod_code"]
        prod_name <- map["prod_name"]
        disb_date <- map["disb_date"]
        tenure <- map["tenure"]
        frequency <- map["frequency"]
        loan_status <- map["loan_status"]
        amount_financed <- map["amount_financed"]
        outstanding_amount <- map["outstanding_amount"]
        outstanding_markup <- map["outstanding_markup"]
        guarantee_details <- map["guarantee_details"]
    }

}

