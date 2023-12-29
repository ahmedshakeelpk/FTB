//
//  BillPaymentCompaniesListDropDown.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 10/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class BillPaymentCompaniesListDropDown: Mappable {
    
    var companies: [SingleCompanyList]?
    var response: Int?
    var message:String?
    var stringCompaniesList = [String]()

    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        companies <- map["data"]
        
        for aCompany in self.companies! {
            stringCompaniesList.append(aCompany.name!)
        }
        
    }
}


class SingleCompanyList : Mappable {
    
    var name : String?
    var code : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        name <- map ["name"]
        code <- map ["code"]
        
        
    }
}
