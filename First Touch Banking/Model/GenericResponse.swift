//
//  GenericResponse.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 08/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class GenericResponse: Mappable {
    
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
    }
}
