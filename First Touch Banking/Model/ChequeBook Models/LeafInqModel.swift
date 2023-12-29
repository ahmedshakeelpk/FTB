//
//  LeafInqModel.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper

struct LeafInq: Mappable {
    var response : Int?
    var message : String?
    var LIdata : [LeafInquiry]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        LIdata <- map["data"]
    }
    
   
}
struct LeafInquiry : Mappable {
    var leaf_no : [Leaf_no]?
    var chequebook_no : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        leaf_no <- map["leaf_no"]
        chequebook_no <- map["chequebook_no"]
    }

}
struct Leaf_no : Mappable {
    var value : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        value <- map["value"]
    }

}
