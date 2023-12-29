//
//  MaintenanceCertificateModel.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

struct MaintenanceCertificate : Mappable {
    var response : Int?
    var message : String?
    var MCdata : [MCModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        MCdata <- map["data"]
    }

}
struct MCModel : Mappable {
    var vAccount : String?
    var vTitleofAccount : String?
    var vCNICNo : String?
    var vIBAN : String?
    var vBranchName : String?
    var vBranchCode : String?
    var vAccountOpeningDate : String?
    var vAccountStatus : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        vAccount <- map["VAccount"]
        vTitleofAccount <- map["VTitleofAccount"]
        vCNICNo <- map["VCNICNo"]
        vIBAN <- map["VIBAN"]
        vBranchName <- map["VBranchName"]
        vBranchCode <- map["VBranchCode"]
        vAccountOpeningDate <- map["VAccountOpeningDate"]
        vAccountStatus <- map["VAccountStatus"]
    }

}
