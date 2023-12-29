//
//  MoviePaymentSuccess.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 06/11/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class  MoviePaymentSuccess: Mappable {
    
    var response: Int?
    var message:String?
    
    
    var status:String?
    var msg:String?
    var booking_id:String?
    var orderRefNumber:String?
    var order:String?
    var bookme_booking_id:String?
    var booking_reference:String?
    var cinema:String?
    var screen:String?
    var movie:String?
    var seats:String?
    var net_amount:String?
    var total_amount:String?
    var name:String?
    var phone:String?
    var email:String?
    var city:String?
    var address:String?
    var seat_numbers:String?
    var seat_preference:String?
    var date:String?
    var time:String?




    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]

        status <- map["data.status"]
        msg <- map["data.msg"]
        booking_id <- map["data.booking_id"]
        orderRefNumber <- map["data.orderRefNumber"]
        order <- map["data.order"]
        bookme_booking_id <- map["data.bookme_booking_id"]
        booking_reference <- map["data.booking_reference"]
        cinema <- map["data.cinema"]
        screen <- map["data.screen"]
        movie <- map["data.movie"]
        seats <- map["data.seats"]
        net_amount <- map["data.net_amount"]
        total_amount <- map["data.total_amount"]
        name <- map["data.name"]
        phone <- map["data.phone"]
        email <- map["data.email"]
        city <- map["data.city"]
        address <- map["data.address"]
        seat_numbers <- map["data.seat_numbers"]
        seat_preference <- map["data.seat_preference"]
        date <- map["data.date"]
        time <- map["data.time"]


        
    }
}

