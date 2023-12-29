//
//  StatusCheck.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

struct StatusCheckModel : Mappable {
    var response : Int?
    var message : String?
    var SCdata : [StatusCheck]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        SCdata <- map["data"]
    }

}
struct StatusCheck : Mappable {
    var vAccount : String?
    var vFirst_check_no : String?
    var vCHeck_leaves : String?
    var vOrder_Date : String?
    var vIssue_Date : String?
    var vREQUEST_STATUS : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        vAccount <- map["VAccount"]
        vFirst_check_no <- map["VFirst_check_no"]
        vCHeck_leaves <- map["VCHeck_leaves"]
        vOrder_Date <- map["VOrder_Date"]
        vIssue_Date <- map["VIssue_Date"]
        vREQUEST_STATUS <- map["VREQUEST_STATUS"]
    }

}
