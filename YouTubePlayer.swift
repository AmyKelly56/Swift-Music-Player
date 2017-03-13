//
//  YouTubePlayer.swift
//  App
//
//  Created by Amy Kelly on 13/03/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import UIKit

class YouTubePlayer: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    public class YouTubePlayerView: UIView, UIWebViewDelegate {
        
        public typealias YouTubePlayerParameters = [String: AnyObject]
        
        private var webView: UIWebView!
        
        /** The readiness of the player */
        private(set) public var ready = false
        
        /** The current state of the video player */
        private(set) public var playerState = YouTubePlayerState.Unstarted
        
        /** The current playback quality of the video player */
        private(set) public var playbackQuality = YouTubePlaybackQuality.Small
        
        /** Used to configure the player */
        public var playerVars = YouTubePlayerParameters()
        
        /** Used to respond to player events */
        public var delegate: YouTubePlayerDelegate?


}
