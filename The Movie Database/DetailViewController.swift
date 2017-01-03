//
//  DetailViewController.swift
//  The Movie Database
//
//  Created by Marcelo Cotrim on 02/01/17.
//  Copyright © 2017 Marcelo Cotrim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    fileprivate var movie: Movie!
    fileprivate var scrollView: UIScrollView!
    fileprivate var posterImageView: UIImageView!
    fileprivate var genresLabel: UILabel!
    fileprivate var overviewLabel: UILabel!
    fileprivate var releaseDateLabel: UILabel!
    
    //view controller initialization
    init(_ movie: Movie) {
        super.init(nibName: nil, bundle: nil)
        self.movie = movie
        scrollView = UIScrollView(frame: UIScreen.main.bounds)
        posterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 1.5))
        genresLabel = UILabel(frame: CGRect(x: 10, y: posterImageView.bounds.height, width: UIScreen.main.bounds.width - 20, height: 20))
        releaseDateLabel = UILabel(frame: CGRect(x: 10, y: posterImageView.bounds.height + 20, width: UIScreen.main.bounds.width - 20, height: 20))
        overviewLabel = UILabel(frame: CGRect(x: 10, y: posterImageView.bounds.height + 50, width: UIScreen.main.bounds.width - 20, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //layout of view and subviews
        layout()
    }
    
    //layout of view and subviews
    func layout() {
        navigationItem.title = movie.title
        view.backgroundColor = .gray()
        view.addSubview(scrollView)
        
        scrollView.addSubview(posterImageView)
        scrollView.addSubview(genresLabel)
        scrollView.addSubview(releaseDateLabel)
        scrollView.addSubview(overviewLabel)
        
        posterImageView.backgroundColor = .white
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.load(url: movie.posterPath, width: 640) { (error) in
        }
        genresLabel.text = ""
        for genre in movie.genreIds! {
            if let genreName = App.shared.genres.object(forKey: "\(genre)") as? String {
                genresLabel.text = genresLabel.text!.appending(genreName)+","
            }
        }
        genresLabel.text?.characters.removeLast()
        genresLabel.font = UIFont.italicSystemFont(ofSize: 12)
        genresLabel.textColor = .white
        genresLabel.numberOfLines = 0
        genresLabel.lineBreakMode = .byWordWrapping
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        releaseDateLabel.text = "RELEASE DATE: "+formatter.string(from: movie.releaseDate)
        releaseDateLabel.font = UIFont.systemFont(ofSize: 12)
        releaseDateLabel.textColor = .white
        
        overviewLabel.text = "OVERVIEW:\n"+movie.overview
        overviewLabel.font = UIFont.systemFont(ofSize: 12)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byWordWrapping
        overviewLabel.sizeToFit()
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: overviewLabel.bounds.height + 40 + posterImageView.bounds.height + 84)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
