//
//  RelinkAlias.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 11/03/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation

import ObjectMapper

struct Relinkailas : Mappable {
    var response : Int?
    var message : String?
    var relink : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        relink <- map["data"]
    }

}
