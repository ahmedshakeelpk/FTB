//
//  GetIpLocationModel.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 31/08/2020.
//  Copyright © 2020 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetIpLocationModel : Mappable {
    var query : String?
    var status : String?
    var country : String?
    var countryCode : String?
    var region : String?
    var regionName : String?
    var city : String?
    var zip : String?
    var lat : Double?
    var lon : Double?
    var timezone : String?
    var isp : String?
    var org : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        query <- map["query"]
        status <- map["status"]
        country <- map["country"]
        countryCode <- map["countryCode"]
        region <- map["region"]
        regionName <- map["regionName"]
        city <- map["city"]
        zip <- map["zip"]
        lat <- map["lat"]
        lon <- map["lon"]
        timezone <- map["timezone"]
        isp <- map["isp"]
        org <- map["org"]
    }

}
