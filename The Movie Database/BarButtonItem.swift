//
//  BarButtonItem.swift
//  The Movie Database
//
//  Created by Marcelo Cotrim on 02/01/17.
//  Copyright © 2017 Marcelo Cotrim. All rights reserved.
//

import UIKit

//extension for bar buttons
extension UIBarButtonItem {
    
    class func space(_ width: CGFloat) -> UIBarButtonItem {
        let itemSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        itemSpace.width = width
        return itemSpace
    }
    
    class func search(target: AnyObject, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.plain, target: target, action: action)
    }
}
