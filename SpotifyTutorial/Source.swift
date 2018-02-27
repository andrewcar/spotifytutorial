//
//  Source.swift
//  SpotifyTutorial
//
//  Created by Andrew Carvajal on 2/27/18.
//  Copyright © 2018 Andrew Carvajal. All rights reserved.
//

import Foundation
import Spotify

class Source: NSObject {
    
    static let si = Source()
    fileprivate override init() {}
    
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var spotifyPlayer: SPTAudioStreamingController!
}
