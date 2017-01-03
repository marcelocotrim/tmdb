//
//  Movie.swift
//  The Movie Database
//
//  Created by Marcelo Cotrim on 02/01/17.
//  Copyright © 2017 Marcelo Cotrim. All rights reserved.
//

import UIKit

//movie class
class Movie: NSObject {

    var posterPath: String?
    var isAdult: Bool!
    var overview: String!
    var releaseDate: Date!
    var genreIds: [NSInteger]?
    var id: NSInteger!
    var originalTitle: String!
    var originalLanguage: String!
    var title: String!
    var backdropPath: String?
    var popularity: CGFloat!
    var voteCount: NSInteger!
    var video: Bool!
    var voteAverage: CGFloat!
    
    //inialization class with the json parse
    init(_ dictionary: NSDictionary) {
        super.init()
        posterPath = dictionary["poster_path"] as? String
        isAdult = dictionary["adult"] as! Bool
        overview = dictionary["overview"] as! String
        releaseDate = Formatter().date(from: dictionary["release_date"] as! String)
        genreIds = dictionary["genre_ids"] as? [NSInteger]
        id = dictionary["id"] as! NSInteger
        originalTitle = dictionary["original_title"] as! String
        originalLanguage = dictionary["original_language"] as! String
        title = dictionary["title"] as! String
        backdropPath = dictionary["backdrop_path"] as? String
        popularity = dictionary["popularity"] as! CGFloat
        voteCount = dictionary["vote_count"] as! NSInteger
        video = dictionary["video"] as! Bool
        voteAverage = dictionary["vote_average"] as! CGFloat
    }
}
