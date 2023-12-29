//
//  BeneficiaryModel.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 26/01/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct Beneficiarymodel : Mappable {
    var response : Int?
    var message : String?
    var data : [BenefList]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        data <- map["data"]
    }

}
struct BenefList : Mappable {
    var id : Int?
    var name : String?
    var mobile : String?
    var email : String?
    var account : String?
    var beneficiary_company : String?
    var beneficiary_code : String?
    var beneficiary_type : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        mobile <- map["mobile"]
        email <- map["email"]
        account <- map["account"]
        beneficiary_company <- map["beneficiary_company"]
        beneficiary_code <- map["beneficiary_code"]
        beneficiary_type <- map["beneficiary_type"]
    }

}

