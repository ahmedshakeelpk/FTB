//
//  AtmLocator.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 12/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class AtmLocator: Mappable {
    
    var atmLocators: [SingleAtmLocator]?
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        response <- map["response"]
        message <- map["message"]
        atmLocators <- map["data"]
    }
}


class SingleAtmLocator : Mappable {
    
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
    var email : String?

    
    
    
    
    
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
        email <- map ["email"]

        
        
        
        
    }
}

/*
 {
 "data": [
 {
 "id": 5,
 "code": "002",
 "name": "FMFB Rawalpindi Branch",
 "address": "FMFB, Chandni Chowk Murree Road Rawalpindi",
 "area": "Rawalpindi",
 "lat": 33.630000000000003,
 "lng": 73.069999999999993,
 "contact_person": null,
 "landline": "+92 0514419978",
 "mobile": null,
 "email": "rawalpindi@mfb.com.pk",
 "type": "atm",
 "created_at": null,
 "updated_at": null
 }
 ]
 }
 
 */
