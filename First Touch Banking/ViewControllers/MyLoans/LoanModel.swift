//
//  LoanModel.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 16/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct LoansModel: Mappable {
    var response : Int?
    var message : String?
    var data : [LoanDetail]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        data <- map["data"]
    }

}
struct LoanDetail : Mappable {
    var account_number : String?
    var mn_installment_due_date : String?
    var principal_due : String?
    var service_charges_due : String?
    var actual_installment : String?
    var amount_paid : String?
    var mx_paid_date : String?
    var delay_in_days : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        account_number <- map["account_number"]
        mn_installment_due_date <- map["mn_installment_due_date"]
        principal_due <- map["principal_due"]
        service_charges_due <- map["service_charges_due"]
        actual_installment <- map["actual_installment"]
        amount_paid <- map["amount_paid"]
        mx_paid_date <- map["mx_paid_date"]
        delay_in_days <- map["delay_in_days"]
    }

}
