//
//  RadioViewController.swift
//  App
//
//  Created by Amy Kelly on 08/03/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import UIKit

class RadioViewController: UIViewController {
    
    let kClientId = "2932d20ab2e5426dba6becb2e8c61bcd"
    let kCallbackURL = "SwiftPlayer://returnAfterLogin"
    let kTokenSwapURL = "http://localhost:1234/swap"
    let kTokenRefreshServiceURL = "http://localhost:1234/refresh"
    
    var session:SPTSession?
    
    var player:SPTAudioStreamingController?
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginSpotify(_ sender: Any) {
        
        var auth = SPTAuth.defaultInstance()
        var loginURL = auth.loginURLForClientId(kClientId, declaredRedirectURL: NSURL(string: kCallbackURL), scopes: [SPTAuthStreamingScope])
        
        // Opening a URL in Safari close to application launch may trigger
        // an iOS bug, so we wait a bit before doing so.
        delay(0.1) {
            application.openURL(loginURL)
            return
        }
        
        return true
        
        func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
            // Ask SPTAuth if the URL given is a Spotify authentication callback
            if (SPTAuth.defaultInstance().canHandleURL(url, withDeclaredRedirectURL: NSURL(string:kCallbackURL))) {
                SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, tokenSwapServiceEndpointAtURL: NSURL(string: kTokenSwapURL), callback: { (error, session) -> Void in
                    if (error != nil) {
                        println("*** Auth error: \(error)")
                        return
                    }
                    
                    self.playUsingSession(session)
                })
                
                return true
            }
            
            return false
        }
        
        func playUsingSession(session:SPTSession) {
            // Create a new player if needed
            if (self.player == nil) {
                self.player = SPTAudioStreamingController()
            }
            self.player?.loginWithSession(session, callback: { (error) -> Void in
                if (error != nil) {
                    println("*** Enabling playback got error: \(error)")
                    return
                } else {
                    
                    SPTRequest.requestItemAtURI(NSURL(string: "spotify:album:3vGtqTr5he9uQfusQWJ0oC"), withSession: session, callback: { (error, album) -> Void in
                        if (error != nil) {
                            println("*** Album lookup got error \(error)")
                            return
                        }
                        self.player?.playTrackProvider(album as SPTAlbum, callback: nil)
                        
                    })
                }
            })
            
        }
        
        UIApplication.sharedApplicationWarning().openURL(loginURL)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    

    
    // MARK: - Navigation

 

}
