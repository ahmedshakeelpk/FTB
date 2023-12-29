//
//  MovieList.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 18/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class MovieList: Mappable {
    
    var movies: [SingleMovie]?
    var response: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        response <- map["response"]
        message <- map["message"]
        movies <- map["data"]
        
        
    }
}


class SingleMovie : Mappable {
    
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
 
    }
}

/*
 
 "movie_id": "866",
 "imdb_id": "tt5664636",
 "title": "Goosebumps 2 Haunted Halloween",
 "genre": "Comedy, Adventure, Family",
 "language": "English",
 "director": "Ari Sandel",
 "producer": "Deborah Forte",
 "release_date": "2018-10-12",
 "cast": "Jack Black, Wendi McLendon-Covey, Madison Iseman",
 "ranking": "6",
 "length": "83",
 "thumbnail": "https://bookme.pk/custom/upload/GB2_IMDB.jpg"
 
 */
