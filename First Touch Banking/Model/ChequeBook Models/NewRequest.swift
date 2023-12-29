//
//  NewRequest.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper

struct NewRequest: Mappable {
    var response : Int?
    var message : String?
    var NewRequestdata : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        NewRequestdata <- map["data"]
    }

}
