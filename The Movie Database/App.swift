//
//  App.swift
//  The Movie Database
//
//  Created by Marcelo Cotrim on 02/01/17.
//  Copyright © 2017 Marcelo Cotrim. All rights reserved.
//

import UIKit
import Alamofire

//global constants
struct GlobalConstants {
    static let tmdbURL: String = "https://api.themoviedb.org/3"
    static let tmdbImageURL: String = "https://image.tmdb.org/t/p/"
    static let tmdbAPIKey: String = "1f54bd990f1cdfb230adb312546d765d"
}

class App {
    
    //singleton for the class
    static let shared = App()
    
    var genres: NSMutableDictionary!
    
    //get the genres list from the tmdb
    func genres(block: @escaping (_ error: String?) -> Void) {
        let url = GlobalConstants.tmdbURL + "/genre/movie/list"
        var parameters = Parameters()
        parameters["api_key"] = GlobalConstants.tmdbAPIKey
        Alamofire.request(url, method: .get, parameters: parameters)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let value as NSDictionary):
                    self.genres = NSMutableDictionary()
                    if let dictionaries = value["genres"] as? [NSDictionary] {
                        for dictionary in dictionaries {
                            self.genres[NumberFormatter().string(from: NSNumber(value: dictionary["id"] as! NSInteger))!] = dictionary["name"] as! String
                        }
                    }
                    block(nil)
                case .failure(_):
                    block(response.result.error!.localizedDescription)
                default:
                    block(nil)
                }
        }
    }
    
    //get the upcoming movies list from the tmdb
    func upcomingMovies(_ page: NSInteger, block: @escaping (_ movies: [Movie]?, _ totalPages: NSInteger?, _ error: String?) -> Void) {
        let url = GlobalConstants.tmdbURL + "/movie/upcoming"
        var parameters = Parameters()
        parameters["api_key"] = GlobalConstants.tmdbAPIKey
        parameters["page"] = page
        Alamofire.request(url, method: .get, parameters: parameters)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let value as NSDictionary):
                    var movies = [Movie]()
                    if let dictionaries = value["results"] as? [NSDictionary] {
                        for dictionary in dictionaries {
                            movies.append(Movie(dictionary))
                        }
                    }
                    block(movies, value["total_pages"] as? NSInteger, nil)
                case .failure(_):
                    block(nil, nil, response.result.error!.localizedDescription)
                default:
                    block(nil, nil, nil)
                }
        }
    }
    
    //search for movies from the tmdb
    func searchMovies(_ query: String, _ page: NSInteger, block: @escaping (_ movies: [Movie]?, _ totalPages: NSInteger?, _ error: String?) -> Void) {
        let url = GlobalConstants.tmdbURL + "/search/movie"
        var parameters = Parameters()
        parameters["api_key"] = GlobalConstants.tmdbAPIKey
        parameters["page"] = page
        parameters["query"] = query
        Alamofire.request(url, method: .get, parameters: parameters)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let value as NSDictionary):
                    var movies = [Movie]()
                    if let dictionaries = value["results"] as? [NSDictionary] {
                        for dictionary in dictionaries {
                            movies.append(Movie(dictionary))
                        }
                    }
                    block(movies, value["total_pages"] as? NSInteger, nil)
                case .failure(_):
                    block(nil, nil, response.result.error!.localizedDescription)
                default:
                    block(nil, nil, nil)
                }
        }
    }
}
