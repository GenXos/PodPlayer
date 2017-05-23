//
//  Parser.swift
//  Pod Player
//
//  Created by Todd Fields on 2017-05-22.
//  Copyright © 2017 SKULLGATE Studios. All rights reserved.
//

import Foundation

class Parser {
    
    func getPodcastMetadata(data: Data) -> (title: String?, imageURL: String?) {
        
        let xml = SWXMLHash.parse(data)
        
        print(xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
        
        return ((xml["rss"]["channel"]["title"].element?.text)!,xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
    
    }
    
}
