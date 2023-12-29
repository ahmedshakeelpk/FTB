//
//  BranchLocator.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 12/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class BranchLocator: Mappable {
    
    var branchLocators: [SingleBranchLocator]?
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        branchLocators <- map["data"]
        
    }
}


class SingleBranchLocator : Mappable {
    
    var id : Int?
    var code : String?
    var name : String?
    var address : String?
    var area : String?
    var lat : Double?
    var lng : Double?
    var contact_person : String?
    var landline : String?
    var type : String?

    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        id <- map["id"]
        code <- map ["code"]
        name <- map ["name"]
        address <- map ["address"]
        area <- map ["area"]
        lat <- map ["lat"]
        lng <- map ["lng"]
        contact_person <- map ["contact_person"]
        landline <- map ["landline"]
        type <- map ["type"]

    }
}


/*
 
 "data": [
 {
 "id": 1,
 "code": "001",
 "name": "THE FIRST MICROFINANCEBANK LTD",
 "address": "16th &17 Floor, HBL Tower, Blue Area, Jinnah Avenue, Islamabad",
 "area": "Punjab",
 "lat": 33.719999999999999,
 "lng": 73.079999999999998,
 "contact_person": null,
 "landline": "+92 0514419978",
 "mobile": null,
 "email": null,
 "type": "branch",
 "created_at": null,
 "updated_at": null
 }
 
 */
