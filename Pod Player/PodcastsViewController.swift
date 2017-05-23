//
//  PodcastsViewController.swift
//  Pod Player
//
//  Created by Todd Fields on 2017-05-22.
//  Copyright © 2017 SKULLGATE Studios. All rights reserved.
//

import Cocoa

class PodcastsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    // MARK: - IBOUTLETS
    @IBOutlet weak var podcastURLTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
 
    // MARK: - Variables
    var podcasts: [Podcast] = []
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        podcastURLTextField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"
        getPodcasts()
    }
    
    // MARK: - Functions
    func getPodcasts() {
 
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let request = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            
            do {
                
                podcasts = try context.fetch(request)
                print(podcasts)
                print(podcasts.count)
            } catch let error as NSError {
                
                fatalError("unable to retrieve records. \(error) \(error.userInfo)")
            }
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    @IBAction func addPodcastClicked(_ sender: Any) {
        
        if let url = URL(string: podcastURLTextField.stringValue) {
            
            URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                
                if error != nil {
                    
                    print(error!)
                } else {
                    
                    if data != nil {
                        let parser = Parser()
                        let info = parser.getPodcastMetadata(data: data!)
                        
                        if !self.podcastExists(rssURL: self.podcastURLTextField.stringValue) {
                            if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
                                
                                let podcast = Podcast(context: context)
                                
                                podcast.rssURL = self.podcastURLTextField.stringValue
                                podcast.imageURL = info.imageURL
                                podcast.title = info.title
                                
                                print(podcast)
                                do {
                                    
                                    try context.save()
                                } catch let error as NSError {
                                    
                                    fatalError("unable to save. \(error) \(error.userInfo)")
                                }
                                self.getPodcasts()                        }
                        }
                    }
                }
                } .resume()
            
            podcastURLTextField.stringValue = ""
            
        }
    }
    
    func podcastExists(rssURL: String) -> Bool {
        
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let request = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            request.predicate = NSPredicate(format: "rssURL == %@", rssURL)
            
            
            do {
                
                let matchingPodcasts = try context.fetch(request)
                
                if matchingPodcasts.count >= 1 {
                    
                    return true
                } else {
                    
                    return false
                }
            } catch let error as NSError {
                
                fatalError("unable to retrieve records. \(error) \(error.userInfo)")
            }
            
        }
        
        return false
    }
    
    // MARK: - TableView 
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return podcasts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.make(withIdentifier: "PodcastCell", owner: self) as? NSTableCellView
            
            let podcast = podcasts[row]
            
            if podcast.title != nil {
                
                cell?.textField?.stringValue = podcast.title!
            } else {
                cell?.textField?.stringValue = "UNKNOWN TITLE"
            }
            return cell
        
    }
}
