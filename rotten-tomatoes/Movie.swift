//
//  Movie.swift
//  rotten-tomatoes
//
//  Created by Josh Lubaway on 2/5/15.
//  Copyright (c) 2015 Frustrated Inc. All rights reserved.
//

import Foundation

struct Movie {
    var title: String
    var description: String
    var thumbnailUrl: NSURL
    
    var originalUrl: NSURL {
        let urlString = thumbnailUrl.absoluteString!
        return NSURL(string: urlString.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: NSStringCompareOptions.LiteralSearch, range: nil))!
    }
}
