//
//  DelinkModel.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 03/01/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct DelinkModel : Mappable {
    var response : Int?
    var message : String?
    var delink : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        delink <- map["data"]
    }

}
