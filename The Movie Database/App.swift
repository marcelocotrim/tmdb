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
                    block(self.error(response))
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
                    block(nil, nil, self.error(response))
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
                    block(nil, nil, self.error(response))
                default:
                    block(nil, nil, nil)
                }
        }
    }
    
    //treats errors from the response of the api and converts to string
    func error(_ response: DataResponse<Any>) -> String {
        if response.data != nil && response.data!.count > 0 {
            do {
                let dictionary = (try JSONSerialization.jsonObject(with: response.data!, options: [])) as? NSDictionary
                if let string = dictionary!["error"] as? String {
                    return NSLocalizedString(string, comment: "")
                }
                if let dictionary = dictionary!["error"] as? NSDictionary {
                    if let string = dictionary["message"] as? String {
                        return NSLocalizedString(string, comment: "")
                    }
                }
            } catch {
                print("erro")
            }
            return response.result.error!.localizedDescription
        } else {
            return response.result.error!.localizedDescription
        }
    }

}
