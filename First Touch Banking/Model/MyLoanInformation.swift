//
//  MyLoanInformation.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 30/07/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper



class  MyLoanInformation: Mappable {
    
    var response: Int?
    var message:String?
    var loanInformation: [SingleLoanInformation]?

    
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        loanInformation <- map["data"]

        

        
    }
}

class SingleLoanInformation : Mappable {
    
    var prod_name : String?
    var disb_date : String?
    var amount_financed : String?
    var outstanding_amount : String?
    var loan_status : String?
    var account_number : String?
    var mn_installment_due_date : String?
    var actual_installment : String?
    var mx_paid_date : String?

    

    
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        prod_name <- map["prod_name"]
        disb_date <- map ["disb_date"]
        amount_financed <- map ["amount_financed"]
        outstanding_amount <- map ["outstanding_amount"]
        loan_status <- map ["loan_status"]
        account_number <- map ["account_number"]
        mn_installment_due_date <- map ["mn_installment_due_date"]
        actual_installment <- map ["actual_installment"]
        mx_paid_date <- map ["mx_paid_date"]



        
    }
}
