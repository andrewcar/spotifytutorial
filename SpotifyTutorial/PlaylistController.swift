//
//  PlaylistController.swift
//  SpotifyTutorial
//
//  Created by Andrew Carvajal on 2/22/18.
//  Copyright © 2018 Andrew Carvajal. All rights reserved.
//

import UIKit
import Alamofire
import Spotify
import AVFoundation

var player = AVAudioPlayer()

struct Post {
    let image: UIImage!
    let name: String!
    let songURI: String!
}

class PlaylistController: UITableViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    var searchURL = String()
    var posts = [Post]()
    typealias JSONStandard = [String: AnyObject]
    var session: SPTSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPlayer()
        searchBar.delegate = self
    }
    
    func getSpotifyCatalogWith(url: String) {
        Alamofire.request(url,
                          method: .get,
                          parameters: ["ids":"0oSGxfWSnnOXhD2fKuz2Gy"],
                          encoding: URLEncoding.default,
                          headers: ["Authorization": "Bearer " + Source.si.session.accessToken]).responseJSON { (response) in
                            self.parseData(JSONData: response.data!)
        }
    }

    func parseData(JSONData: Data) {
        do {
            var parsedJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracks = parsedJSON["tracks"] as? JSONStandard {
                if let items = tracks["items"] as? [JSONStandard] {
                    for i in 0..<items.count {
                        let item = items[i]
                        
                        // name
                        let name = item["name"] as! String
                        
                        // album image
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageJSON = images[0]
                                let imageURL = URL(string: imageJSON["url"] as! String)
                                let imageData = try? Data(contentsOf: imageURL!)
                                let image = UIImage(data: imageData!)
                                
                                // song
                                let songURI = item["uri"] as! String
                                
                                posts.append(Post.init(image: image, name: name, songURI: songURI))
                            }
                        }
                    }
                    tableView.reloadData()
                }
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    func setupPlayer() {
        if Source.si.spotifyPlayer == nil {
            Source.si.spotifyPlayer = SPTAudioStreamingController.sharedInstance()!
        }
        Source.si.spotifyPlayer.playbackDelegate = self
        Source.si.spotifyPlayer.delegate = self
        do {
            try Source.si.spotifyPlayer.start(withClientId: Source.si.auth.clientID)
        } catch {
            print(error.localizedDescription)
        }
        Source.si.spotifyPlayer.login(withAccessToken: Source.si.session.accessToken)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keywords = searchBar.text {
            let finalKeywords = keywords.replacingOccurrences(of: " ", with: "+")
            searchURL = "https://api.spotify.com/v1/search?q=\(finalKeywords)&type=track"
            getSpotifyCatalogWith(url: searchURL)
            searchBar.resignFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let imageView = cell?.viewWithTag(2) as! UIImageView
        imageView.image = posts[indexPath.row].image
        
        let label = cell?.viewWithTag(1) as! UILabel
        label.text = posts[indexPath.row].name
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! AudioController
        vc.albumImage = posts[indexPath!].image
        vc.songTitle = posts[indexPath!].name
        vc.songURI = posts[indexPath!].songURI
    }
}

