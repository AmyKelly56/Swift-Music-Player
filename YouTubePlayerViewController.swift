//
//  YouTubePlayerViewController.swift
//  App
//
//  Created by Amy Kelly on 13/03/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import UIKit
import YouTubePlayer

class YouTubePlayerViewController: UIViewController {
    
    //var videoURL: NSURL!
   // @IBOutlet weak var youtubePlayerView : YouTubePlayerView!
    
    @IBOutlet var youtubePlayer: YouTubePlayerView!
    var YouTubePlayer = YouTubePlayerView.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*if let videoURL = videoURL {
            youtubePlayerView.loadVideoURL(videoURL: videoURL!)
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Video cannot be displayed", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
 */
        
        
        youtubePlayer.loadVideoID(videoID: "nfWlot6h_JM")
        // Load video from YouTube URL
        let myVideoURL = NSURL(string: "https://www.youtube.com/watch?v=wQg3bXrVLtg")
        youtubePlayer.loadVideoURL(videoURL: myVideoURL!)
    }
}
