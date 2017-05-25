//
//  Episode.swift
//  Pod Player
//
//  Created by Todd Fields on 2017-05-25.
//  Copyright © 2017 SKULLGATE Studios. All rights reserved.
//

import Cocoa

class Episode {
    
    var title = ""
    var htmlDescription = ""
    var audioURL = ""
    var pubDate = Date()
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()

}
