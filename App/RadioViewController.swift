//
//  RadioViewController.swift
//  App
//
//  Created by Amy Kelly on 08/03/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import UIKit

class RadioViewController: UIViewController {

    @IBOutlet weak var videoView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         getVideo(videoCode: "jSGI2Cx_fME")

    }

    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    
    func getVideo(videoCode: String)
    {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        videoView.loadRequest(URLRequest(url: url!))
    }
    


 

}
