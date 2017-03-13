//
//  YouTubePlayerViewController.swift
//  App
//
//  Created by Amy Kelly on 13/03/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import UIKit

class YouTubePlayerViewController: UIViewController {
    
    var videoURL: NSURL!
    @IBOutlet weak var youtubePlayerView : YouTubePlayerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let videoURL = videoURL {
            youtubePlayerView.loadVideoURL(videoURL)
        }
        else {
            let alertController = UIAlertController(title: "error", message: "Video cannot be displayed", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
