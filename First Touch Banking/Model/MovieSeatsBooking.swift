//
//  MovieSeatsBooking.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


struct MovieSeatsBooking : Mappable {
    var response : Int?
    var message : String?
    var data : DataMovies?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        data <- map["data"]
    }
    

    
}

class DataMovies: Mappable {
    
    var show_id : String?
    var hall_id : String?
    var hall_name : String?
    var rows : String?
    var cols : String?
    var seat_plan : [Seat_plan]?
    var booked_seats : [String]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        show_id <- map["show_id"]
        hall_id <- map["hall_id"]
        hall_name <- map["hall_name"]
        rows <- map["rows"]
        cols <- map["cols"]
        seat_plan <- map["seat_plan"]
        booked_seats <- map["booked_seats"]
        
    }
}

class Seat_plan : Mappable {
    var row : String?
    var place : String?
    var seats : [Seats]?
    
    required init?(map: Map){ }
    
   func mapping(map: Map) {
        
        row <- map["row"]
        place <- map["place"]
        seats <- map["seats"]
    }
}

class Seats : Mappable {
    var seat_id : String?
    var seat_row_name : String?
    var seat_number : String?
    var seat_type : String?
    var status : Int?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        seat_id <- map["seat_id"]
        seat_row_name <- map["seat_row_name"]
        seat_number <- map["seat_number"]
        seat_type <- map["seat_type"]
        status <- map["status"]
    }
}



