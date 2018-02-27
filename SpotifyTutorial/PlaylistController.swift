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

struct Post {
    let image: UIImage!
    let name: String!
}

class PlaylistController: UITableViewController {

    var searchURL = "Https://api.spotify.com/v1/search?q=Future&type=track"
    var posts = [Post]()
    typealias JSONStandard = [String: AnyObject]
    var session: SPTSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getSpotifyCatalogWith(url: searchURL)
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
                        let name = item["name"] as! String
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageJSON = images[0]
                                let imageURL = URL(string: imageJSON["url"] as! String)
                                let imageData = try? Data(contentsOf: imageURL!)
                                let image = UIImage(data: imageData!)
                                posts.append(Post.init(image: image, name: name))
                                tableView.reloadData()
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
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
    }
}

