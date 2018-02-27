//
//  SignInController.swift
//  SpotifyTutorial
//
//  Created by Andrew Carvajal on 2/26/18.
//  Copyright © 2018 Andrew Carvajal. All rights reserved.
//

import UIKit
import Spotify

class SignInController: UIViewController {
    
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var player: SPTAudioStreamingController?
    var loginURL: URL?
    
    func setupSpotify() {
        SPTAuth.defaultInstance().clientID = "e24281f151964caa91c42138c4f7c4a0"
        SPTAuth.defaultInstance().redirectURL = URL(string: "spotifytutorial://returnafterlogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope,
                                                     SPTAuthPlaylistReadPrivateScope,
                                                     SPTAuthPlaylistModifyPublicScope,
                                                     SPTAuthPlaylistModifyPrivateScope]
        loginURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpotify()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SignInController.updateAfterLogin),
                                               name: .connectionCompleted,
                                               object: nil)
        
        if UserDefaults.standard.data(forKey: "SpotifySession") != nil {
            updateAfterLogin()
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        if UIApplication.shared.canOpenURL(loginURL!) {
            if auth.canHandle(auth.redirectURL) {
                UIApplication.shared.open(loginURL!, options: [:], completionHandler: { (success) in
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaylistControllerSegue" {
            let playlistController = segue.destination as? PlaylistController
            playlistController?.session = session
        }
    }
    
    @objc func updateAfterLogin() {
        if let sessionObj: AnyObject = UserDefaults().object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "PlaylistControllerSegue", sender: self)
            }
        }
    }
    
}

extension Notification.Name {
    static let connectionCompleted = Notification.Name(
        rawValue: "loginSuccessfull")
}
