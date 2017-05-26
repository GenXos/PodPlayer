//
//  EpisodesViewController.swift
//  Pod Player
//
//  Created by Todd Fields on 2017-05-23.
//  Copyright © 2017 SKULLGATE Studios. All rights reserved.
//

import Cocoa
import AVFoundation

class EpisodesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var pausePlayButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    //MARK: - Variables
    //
    var podcastsVC : PodcastsViewController? = nil
    var podcast : Podcast? = nil
    var episodes : [Episode] = []
    var player : AVPlayer? = nil

    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pausePlayButton.isHidden = true
        imageView.image = nil
        titleLabel.stringValue = ""
    }
    
    // MARK: - Functions
    func updateView() {
        
        if podcast?.title != nil {
            titleLabel.stringValue = (podcast?.title)!
        } else {
            titleLabel.stringValue = ""
        }
        
        if podcast?.imageURL != nil {
            
            let image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
            imageView.image = image
        } else {
            imageView.image = nil
        }
        
        getEpisodes()
    }
    
    func getEpisodes() {
        
        if podcast?.rssURL != nil {
            
            if let url = URL(string: podcast!.rssURL!) {
            
            URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                
                if error != nil {
                    
                    print(error!)
                } else {
                    
                    if data != nil {
                        let parser = Parser()
                        self.episodes = parser.getEpisodes(data: data!)
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                        }
                    }
                }
                }.resume()
            }
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        
        if podcast != nil {
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                do {
                    
                    context.delete(podcast!)
                    try context.save()
                    
                    podcastsVC?.getPodcasts()
                    
                    podcast = nil
                    updateView()
                } catch let error as NSError {
                    
                    fatalError("Unable to delete podcast. \(error) \(error.userInfo)")
                }
                
            }
        }
    }
    
    @IBAction func pausePlayClicked(_ sender: Any) {
        
        if pausePlayButton.title == "Pause" {
            
            player?.pause()
            pausePlayButton.title = "Play"
        } else {
            
            player?.play()
            pausePlayButton.title = "Pause"
        }
        
    }
    
    // MARK: - TableView
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return episodes.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let episode = episodes[row]
        let cell = tableView.make(withIdentifier: "EpisodesCell", owner: self) as? EpisodeCell
        cell?.titleLabel.stringValue = episode.title
        cell?.descriptionWebView.loadHTMLString(episode.htmlDescription, baseURL: nil)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        cell?.pubDateLabel.stringValue = dateFormatter.string(from: episode.pubDate)
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        return 100
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        if tableView.selectedRow >= 0 {
            
            let episode = episodes[tableView.selectedRow]
            if let url = URL(string: episode.audioURL) {
                
                player?.pause()
                player = nil
                player = AVPlayer(url: url)
                player?.play()
            }
            pausePlayButton.isHidden = false
            pausePlayButton.title = "Pause"        }
    }
}





























