//
//  Formatter.swift
//  The Movie Database
//
//  Created by Marcelo Cotrim on 02/01/17.
//  Copyright © 2017 Marcelo Cotrim. All rights reserved.
//

import UIKit

//class to format the release date
class Formatter: DateFormatter {
    
    static let shared = Formatter()
    
    override init() {
        super.init()
        self.locale = NSLocale.system
        self.dateFormat = "yyyy-MM-dd"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
