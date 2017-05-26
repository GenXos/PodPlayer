//
//  EpisodeCell.swift
//  Pod Player
//
//  Created by Todd Fields on 2017-05-26.
//  Copyright © 2017 SKULLGATE Studios. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var pubDateLabel: NSTextField!
    @IBOutlet weak var descriptionWebView: WKWebView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
    }
    
}
