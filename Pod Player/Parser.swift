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
        
        print(xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text as Any)
        
        return ((xml["rss"]["channel"]["title"].element?.text)!,xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
    
    }
    
    func getEpisodes(data: Data) -> [Episode] {
        
        let xml = SWXMLHash.parse(data)
        
        var episodes : [Episode] = []
        
        for item in xml["rss"]["channel"]["item"] {
            
            let episode = Episode()
            
            if let title = item["title"].element?.text {
                
                episode.title = title
            }
            
            if let htmlDescription = item["description"].element?.text {
                
                episode.htmlDescription = htmlDescription
            }
            
            if let audioURL = item["enclosure"].element?.attribute(by: "url")?.text {
                
                episode.audioURL = audioURL
            }
            
            if let pubDate = item["pubDate"].element?.text {
                
                if let date = Episode.formatter.date(from: pubDate) {
                    
                    episode.pubDate = date
                }
            }
            episodes.append(episode)
            //print(episode.pubDate)
        }
        
        return episodes
    }
    
}
