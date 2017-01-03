//
//  MovieTableViewCell.swift
//  The Movie Database
//
//  Created by Marcelo Cotrim on 02/01/17.
//  Copyright © 2017 Marcelo Cotrim. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    fileprivate var movie: Movie!
    fileprivate var view: UIView!
    fileprivate var posterImageView: UIImageView!
    fileprivate var titleLabel: UILabel!
    fileprivate var genresLabel: UILabel!
    fileprivate var releaseDateLabel: UILabel!
    
    //view initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        view = UIView(frame: CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width - 20, height: MovieTableViewCell.height() - 10))
        posterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.height / 1.5, height: view.bounds.height))
        titleLabel = UILabel(frame: CGRect(x: view.bounds.height / 1.5 + 10, y: 10, width: view.bounds.width - 20 - posterImageView.bounds.width, height: 44))
        genresLabel = UILabel(frame: CGRect(x: view.bounds.height / 1.5 + 10, y: 54, width: view.bounds.width - 20 - posterImageView.bounds.width, height: 30))
        releaseDateLabel = UILabel(frame: CGRect(x: view.bounds.height / 1.5 + 10, y: 89, width: view.bounds.width - 20 - posterImageView.bounds.width, height: 20))
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //custom selection style
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
            view.backgroundColor = .lightGray
        } else {
            view.backgroundColor = .white
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.image = nil
    }
    
    //layout for cell
    func layout() {
        selectionStyle = .none
        addSubview(view)
        backgroundColor = .clear
        
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(genresLabel)
        view.addSubview(releaseDateLabel)
        view.backgroundColor = .white
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 2.5
        view.layer.shadowOffset = .zero
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        posterImageView.backgroundColor = .lightGray
        posterImageView.contentMode = .scaleAspectFill
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        genresLabel.font = UIFont.italicSystemFont(ofSize: 12)
        genresLabel.textColor = .gray
        genresLabel.numberOfLines = 0
        genresLabel.lineBreakMode = .byWordWrapping
        
        releaseDateLabel.font = UIFont.systemFont(ofSize: 12)
        releaseDateLabel.textColor = .gray
    }
    
    //layout for movie
    func layout(_ movie: Movie) {
        self.movie = movie
        posterImageView.load(url: movie.posterPath, width: 185) { (error) in
        }
        titleLabel.text = movie.title
        genresLabel.text = ""
        
        for i in 0..<movie.genreIds!.count {
            let genre = movie.genreIds![i]
            if let genreName = App.shared.genres.object(forKey: "\(genre)") as? String {
                genresLabel.text = genresLabel.text!.appending(genreName)+", "
            }
            if i == movie.genreIds!.count - 1 {
                genresLabel.text?.characters.removeLast()
                genresLabel.text?.characters.removeLast()
            }
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        if movie.releaseDate != nil {
            releaseDateLabel.text = "RELEASE DATE: "+formatter.string(from: movie.releaseDate)
        }
    }
    
    //height of the cell
    class func height() -> CGFloat {
        return 132
    }

}
