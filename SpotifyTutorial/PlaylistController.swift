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

    var searchURL = "https://api.spotify.com/v1/artists"
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
                            //print(response)﻿
                            self.parseData(JSONData: response.data!)
        }
    }

    func parseData(JSONData: Data) {
        do {
            var parsedJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as? JSONStandard
            print(parsedJSON)
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
}

