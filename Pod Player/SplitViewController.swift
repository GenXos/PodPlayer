//
//  SplitViewController.swift
//  Pod Player
//
//  Created by Todd Fields on 2017-05-23.
//  Copyright © 2017 SKULLGATE Studios. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var podcastsItem: NSSplitViewItem!
    @IBOutlet weak var episodesItem: NSSplitViewItem!
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let podcastsVC = podcastsItem.viewController as? PodcastsViewController {
            
            if let episodesVC = episodesItem.viewController as? EpisodesViewController {
                
                podcastsVC.episodesVC = episodesVC
                episodesVC.podcastsVC = podcastsVC
            }
        }
    }
    
}
