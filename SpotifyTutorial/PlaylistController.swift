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

class PlaylistController: UITableViewController {

    var searchURL = "Https://api.spotify.com/v1/search?q=Future&type=track"
    var names = [String]()
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
                          headers: ["Authorization": "Bearer " + self.session.accessToken]).responseJSON { (response) in
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
                        names.append(name)
                        tableView.reloadData()
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = names[indexPath.row]
        return cell!
    }
}

