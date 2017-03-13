//
//  RadioViewController.swift
//  App
//
//  Created by Amy Kelly on 08/03/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import UIKit

class RadioViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private struct Storyboard {
        static let showYoutubeSegue = "Show Youtube Player"
    }
    
    private let sampleVideoString = "https://www.youtube.com/watch?v=ECyhMAs1uZM"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showYoutubeSegue {
            let youtubePlayerViewController = segue.destination as! YouTubePlayerViewController
            youtubePlayerViewController.loadVideoURL = NSURL(string: sampleVideoString)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    


 

}
