//
//  MovieShowInfo.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class MovieShowInfo: Mappable {
    
    var response: Int?
    var message:String?
    var movieShows: [SingleMovieShow]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        movieShows <- map["data"]
    }
}


class SingleMovieShow : Mappable {
    
    var movie_id : String?
    var imdb_id : String?
    var title : String?
    var genre : String?
    var language : String?
    var director : String?
    var producer : String?
    var release_date : String?
    var cast : String?
    var ranking : String?
    var length : String?
    var thumbnail : String?
    var music_director : String?
    var country : String?
    var synopsis : String?
    var details : String?
    var trailer_link : String?
    var date : String?
    var booking_type : String?
    var points : String?
    var update_date : String?
    var close_date : String?
    var status : String?
    var shows : [SingleShowInfo]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        movie_id <- map["movie_id"]
        imdb_id <- map ["imdb_id"]
        title <- map ["title"]
        genre <- map ["genre"]
        language <- map ["language"]
        director <- map ["director"]
        producer <- map ["producer"]
        release_date <- map ["release_date"]
        cast <- map ["cast"]
        ranking <- map ["ranking"]
        length <- map ["length"]
        thumbnail <- map ["thumbnail"]
        music_director <- map ["music_director"]
        country <- map ["country"]
        synopsis <- map ["synopsis"]
        details <- map ["details"]
        trailer_link <- map ["trailer_link"]
        date <- map ["date"]
        booking_type <- map ["booking_type"]
        points <- map ["points"]
        update_date <- map ["update_date"]
        close_date <- map ["close_date"]
        status <- map ["status"]
        shows <- map ["shows"]

        
    }
}

class SingleShowInfo : Mappable {
    
    var city_id : String?
    var city_name : String?
    var show_id : String?
    var show_movie_id : String?
    var show_cenima_id : String?
    var cinema_name : String?
    var hall_id : String?
    var hall_name : String?
    var show_date : String?
    var show_start_time : String?
    var show_time : String?
    var ticket_price : String?
    var handling_charges : Double?
    var easypaisa_charges : String?
    var house_full : String?
    var eticket : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        city_id <- map["city_id"]
        city_name <- map ["city_name"]
        show_id <- map ["show_id"]
        show_movie_id <- map ["show_movie_id"]
        show_cenima_id <- map ["language"]
        cinema_name <- map ["cinema_name"]
        hall_id <- map ["hall_id"]
        hall_name <- map ["hall_name"]
        show_date <- map ["show_date"]
        show_start_time <- map ["show_start_time"]
        show_time <- map ["show_time"]
        ticket_price <- map ["ticket_price"]
        handling_charges <- map ["handling_charges"]
        easypaisa_charges <- map ["easypaisa_charges"]
        house_full <- map ["house_full"]
        eticket <- map ["eticket"]
 
    }
}

/*
 
 "data": [
 {
 "shows": [
 {
 "city_id": "1",
 "city_name": "Lahore",
 "show_id": "402127",
 "show_movie_id": "830",
 "show_cenima_id": "8888",
 "cinema_name": "Universal Cinema lahore",
 "hall_id": "151",
 "hall_name": "Screen 6 Regular",
 "show_date": "2018-10-23",
 "show_start_time": "2018-10-23 22:15:00",
 "show_time": "22:15",
 "ticket_price": "500",
 "handling_charges": 25,
 "easypaisa_charges": 0,
 "house_full": "0",
 "eticket": "1"
 },
 
 */
