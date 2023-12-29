//
//  BillPaymentInquiry.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 11/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class BillPaymentInquiry: Mappable {
    
    var response: Int?
    var message:String?
    var stan:String?
    var host_response:String?
    var bill_status:String?
    var customer_name:String?
    var due_date:String?
    var amount:String?
    var amount_with_in_duedate:String?
    var amount_after_duedate:String?
    var utility_company_id:String?
    var additional_data:String?
    var tran_time:String?

    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        stan <- map["data.stan"]
        host_response <- map["data.host_response"]
        bill_status <- map["data.bill_status"]
        customer_name <- map["data.customer_name"]
        due_date <- map["data.due_date"]
        amount <- map["data.amount"]
        amount_with_in_duedate <- map["data.amount_with_in_duedate"]
        amount_after_duedate <- map["data.amount_after_duedate"]
        utility_company_id <- map["data.utility_company_id"]
        additional_data <- map["data.additional_data"]
        tran_time <- map["data.tran_time"]
        
    }
}

/*
 
 "data": {
 "stan": "876849",
 "host_response": "00",
 "bill_status": " ",
 "customer_name": "1801+0000000182100      +00000",
 "due_date": "2018-01-11 15:33:10",
 "amount": "4600T       ",
 "amount_with_in_duedate": "4600T       ",
 "amount_after_duedate": "            ",
 "utility_company_id": "MBLINK02",
 "additional_data": "                                                                                                              ",
 "tran_time": "2018-01-11 15:33:10"
 }

 
 */
