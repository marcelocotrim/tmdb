//
//  ImageView.swift
//  The Movie Database
//
//  Created by Marcelo Cotrim on 02/01/17.
//  Copyright © 2017 Marcelo Cotrim. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireImage

//extension imageview
extension UIImageView {
    
    //load image async with fade transition
    func load(url: String?, width: Int, block: @escaping (_ error: String?) -> Void) {
        if url == nil {
            block(nil)
        } else {
            self.af_setImage(withURL: URL(string: GlobalConstants.tmdbImageURL+"w\(width)/"+url!)!, placeholderImage: nil, filter: nil, progress: { (progress) in
                }, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.25), runImageTransitionIfCached: false, completion: { (response) in
                    block(nil)
            })
        }
    }
}
