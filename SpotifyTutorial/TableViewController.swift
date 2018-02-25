//
//  TableViewController.swift
//  SpotifyTutorial
//
//  Created by Andrew Carvajal on 2/22/18.
//  Copyright © 2018 Andrew Carvajal. All rights reserved.
//

import UIKit
import Alamofire

class TableViewController: UITableViewController {

    var searchURL = "https://api.spotify.com/v1/search?q=Future&type=track&offset=20"
    typealias JSONStandard = [String: AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callAlamo(url: searchURL)
    }
    
    func callAlamo(url: String) {
        Alamofire.request(url).responseJSON { (response) in
            self.parseData(jsonData: response.data!)
        }
    }

    func parseData(jsonData: Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? JSONStandard
            print(readableJSON as Any)
        } catch {
            print(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

