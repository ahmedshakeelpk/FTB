//
//  TransportListModel.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 20/11/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class TransportListModel: Mappable {
    
    var transport: [SingleTransport]?
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        transport <- map["data"]
        
        
    }
}

class SingleTransport : Mappable {
    
    var service_id : String?
    var service_name : String?
    var address : String?
    var phone : String?
    var c_phone : String?
    var status : String?
    var cod : String?
    var flexifare : Int?
    var thumbnail : String?
    var background : String?
    var background_img : String?
    var facilities : String?
    var careem : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        service_id <- map["service_id"]
        service_name <- map ["service_name"]
        address <- map ["address"]
        phone <- map ["phone"]
        c_phone <- map ["c_phone"]
        status <- map ["status"]
        cod <- map ["cod"]
        flexifare <- map ["flexifare"]
        thumbnail <- map ["thumbnail"]
        background <- map ["background"]
        background_img <- map ["background_img"]
        facilities <- map ["facilities"]
        careem <- map ["careem"]
        
    }
}

