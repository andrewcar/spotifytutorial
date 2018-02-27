//
//  AudioController.swift
//  SpotifyTutorial
//
//  Created by Andrew Carvajal on 2/27/18.
//  Copyright © 2018 Andrew Carvajal. All rights reserved.
//

import UIKit

class AudioController: UIViewController {

    var albumImage = UIImage()
    var songTitle = String()
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var songTitleLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        songTitleLabel.text = songTitle
        backgroundImageView.image = albumImage
        mainImageView.image = albumImage
    }
}
