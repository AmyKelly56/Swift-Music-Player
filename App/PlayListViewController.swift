//
//  PlayListViewController.swift
//  App
//
//  Created by Amy Kelly on 27/02/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import UIKit

class PlayListViewController: UIViewController {
    
    @IBOutlet weak var cover1: UIImageView!
    @IBOutlet weak var cover2: UIImageView!
    @IBOutlet weak var cover3: UIImageView!
    @IBOutlet weak var cover4: UIImageView!
    @IBOutlet weak var cover5: UIImageView!
    @IBOutlet weak var cover6: UIImageView!
    @IBOutlet weak var cover7: UIImageView!
    @IBOutlet weak var cover8: UIImageView!
    @IBOutlet weak var cover9: UIImageView!
    @IBOutlet weak var cover10: UIImageView!
    @IBOutlet weak var cover11: UIImageView!
    @IBOutlet weak var cover12: UIImageView!
    
    var covers: [UIImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
         covers = [cover1, cover2, cover3, cover4, cover5, cover6, cover7, cover8, cover9, cover10, cover11, cover12];
        
        updateUI()
        
    }
    
    func updateUI()
    {
        let albums = ColdplayLibrary().albums
        
        for i in 0..<covers.count {
            var cover = covers[i]
            
            let album = albums[i]
            
            if let imageName = album["coverImageName"] as? String {
            cover.image = UIImage(named: imageName)
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
        
    
    }


}
