//
//  YouTubePlayer.swift
//  App
//
//  Created by Amy Kelly on 13/03/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import UIKit

public enum YouTubePlayerState: String {
    case Unstarted = "-1"
    case Ended = "0"
    case Playing = "1"
    case Paused = "2"
    case Buffering = "3"
    case Queued = "4"
}

public enum YouTubePlayerEvents: String {
    case YouTubeIframeAPIReady = "onYouTubeIframeAPIReady"
    case Ready = "onReady"
    case StateChange = "onStateChange"
    case PlaybackQualityChange = "onPlaybackQualityChange"
}

public enum YouTubePlaybackQuality: String {
    case Small = "small"
    case Medium = "medium"
    case Large = "large"
    case HD720 = "hd720"
    case HD1080 = "hd1080"
    case HighResolution = "highres"
}

public protocol YouTubePlayerDelegate {
    func playerReady(videoPlayer: YouTubePlayerView)
    func playerStateChanged(videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState)
    func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality)
}

private extension NSURL {
    func queryStringComponents() -> [String: AnyObject] {
        
        var dict = [String: AnyObject]()
        
        // Check for query string
        if let query = self.query {
            
            // Loop through pairings (separated by &)
            for pair in query.componentsSeparatedBy("&") {
                
                // Pull key, val from from pair parts (separated by =) and set dict[key] = value
                let components = pair.componentsSeparatedBy("=")
                dict[components[0]] = components[1]
            }
            
        }
        
        return dict
    }
}

public func videoIDFromYouTubeURL(videoURL: NSURL) -> String? {
    if let host = videoURL.host, let pathComponents = videoURL.pathComponents, pathComponents.count > 1 && host.hasSuffix("youtu.be") {
        return pathComponents[1]
    }
    return videoURL.queryStringComponents()["v"] as? String
}

/** Embed and control YouTube videos */
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
    
    
    // MARK: Various methods for initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        buildWebView(parameters: playerParameters())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildWebView(parameters: playerParameters())
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // Remove web view in case it's within view hierarchy, reset frame, add as subview
        webView.removeFromSuperview()
        webView.frame = bounds
        addSubview(webView)
    }
    
    
    // MARK: Web view initialization
    
    private func buildWebView(parameters: [String: AnyObject]) {
        webView = UIWebView()
        webView.allowsInlineMediaPlayback = true
        webView.mediaPlaybackRequiresUserAction = false
        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
    }
    
    
    // MARK: Load player
    
    public func loadVideoURL(videoURL: NSURL) {
        if let videoID = videoIDFromYouTubeURL(videoURL: videoURL) {
            loadVideoID(videoID: videoID)
        }
    }
    
    public func loadVideoID(videoID: String) {
        var playerParams = playerParameters()
        playerParams["videoId"] = videoID as AnyObject?
        
        loadWebViewWithParameters(parameters: playerParams)
    }
    
    public func loadPlaylistID(playlistID: String) {
        // No videoId necessary when listType = playlist, list = [playlist Id]
        playerVars["listType"] = "playlist" as AnyObject?
        playerVars["list"] = playlistID as AnyObject?
        
        loadWebViewWithParameters(parameters: playerParameters())
    }
    
    
    // MARK: Player controls
    
    public func play() {
        evaluatePlayerCommand(command: "playVideo()")
    }
    
    public func pause() {
        evaluatePlayerCommand(command: "pauseVideo()")
    }
    
    public func stop() {
        evaluatePlayerCommand(command: "stopVideo()")
    }
    
    public func clear() {
        evaluatePlayerCommand(command: "clearVideo()")
    }
    
    public func seekTo(seconds: Float, seekAhead: Bool) {
        evaluatePlayerCommand(command: "seekTo(\(seconds), \(seekAhead))")
    }
    
    // MARK: Playlist controls
    
    public func previousVideo() {
        evaluatePlayerCommand(command: "previousVideo()")
    }
    
    public func nextVideo() {
        evaluatePlayerCommand(command: "nextVideo()")
    }
    
    private func evaluatePlayerCommand(command: String) {
        let fullCommand = "player." + command + ";"
        webView.stringByEvaluatingJavaScript(from: fullCommand)
    }
    
    
    // MARK: Player setup
    
    private func loadWebViewWithParameters(parameters: YouTubePlayerParameters) {
        
        // Get HTML from player file in bundle
        let rawHTMLString = htmlStringWithFilePath(path: playerHTMLPath())!
        
        // Get JSON serialized parameters string
        let jsonParameters = serializedJSON(object: parameters as AnyObject)!
        
        // Replace %@ in rawHTMLString with jsonParameters string
        let htmlString = rawHTMLString.stringByReplacingOccurrencesOfString("%@", withString: jsonParameters)
        
        // Load HTML in web view
        webView.loadHTMLString(htmlString, baseURL: NSURL(string: "about:blank"))
    }
    
    private func playerHTMLPath() -> String {
        return Bundle(for: self.classForCoder).path(forResource: "YTPlayer", ofType: "html")!
    }
    
    private func htmlStringWithFilePath(path: String) -> String? {
        
        do {
            
            // Get HTML string from path
            let htmlString = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            
            return htmlString as String
            
        } catch _ {
            
            // Error fetching HTML
            printLog(strings: "Lookup error: no HTML file found for path")
            
            return nil
        }
    }
    
    
    // MARK: Player parameters and defaults
    
    private func playerParameters() -> YouTubePlayerParameters {
        
        return [
            "height": "100%" as AnyObject,
            "width": "100%" as AnyObject,
            "events": playerCallbacks() as AnyObject,
            "playerVars": playerVars as AnyObject
        ]
    }
    
    private func playerCallbacks() -> YouTubePlayerParameters {
        return [
            "onReady": "onReady" as AnyObject,
            "onStateChange": "onStateChange" as AnyObject,
            "onPlaybackQualityChange": "onPlaybackQualityChange" as AnyObject,
            "onError": "onPlayerError" as AnyObject
        ]
    }
    
    private func serializedJSON(object: AnyObject) -> String? {
        
        do {
            // Serialize to JSON string
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            // Succeeded
            return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as? String
            
        } catch let jsonError {
            
            // JSON serialization failed
            print(jsonError)
            printLog(strings: "Error parsing JSON")
            
            return nil
        }
    }
    
    
    // MARK: JS Event Handling
    
    private func handleJSEvent(eventURL: NSURL) {
        
        // Grab the last component of the queryString as string
        let data: String? = eventURL.queryStringComponents()["data"] as? String
        
        if let host = eventURL.host, let event = YouTubePlayerEvents(rawValue: host) {
            
            // Check event type and handle accordingly
            switch event {
            case .YouTubeIframeAPIReady:
                ready = true
                break
                
            case .Ready:
                delegate?.playerReady(videoPlayer: self)
                
                break
                
            case .StateChange:
                if let newState = YouTubePlayerState(rawValue: data!) {
                    playerState = newState
                    delegate?.playerStateChanged(videoPlayer: self, playerState: newState)
                }
                
                break
                
            case .PlaybackQualityChange:
                if let newQuality = YouTubePlaybackQuality(rawValue: data!) {
                    playbackQuality = newQuality
                    delegate?.playerQualityChanged(videoPlayer: self, playbackQuality: newQuality)
                }
                
                break
            }
        }
    }
    
    
    // MARK: UIWebViewDelegate
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = request.url
        
        // Check if ytplayer event and, if so, pass to handleJSEvent
        if let url = url, url.scheme == "ytplayer" { handleJSEvent(eventURL: url as NSURL) }
        
        return true
    }
}

private func printLog(strings: CustomStringConvertible...) {
    let toPrint = ["[YouTubePlayer]"] + strings
    print(toPrint, separator: " ", terminator: "\n")
}

