//
//  PlayListViewController.swift
//  App
//
//  Created by Amy Kelly on 27/02/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import UIKit

class PlayListViewController: UIViewController {
    
    
    //MARK : Properities
    
    @IBOutlet weak var cover1: UIImageView!
    @IBOutlet weak var cover2: UIImageView!
    @IBOutlet weak var cover3: UIImageView!
    @IBOutlet weak var cover4: UIImageView!
    @IBOutlet weak var cover5: UIImageView!
    @IBOutlet weak var cover6: UIImageView!
    @IBOutlet weak var cover7: UIImageView!
    @IBOutlet weak var cover8: UIImageView!
  
    
    var covers: [UIImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
         covers = [cover1, cover2, cover3, cover4, cover5, cover6, cover7, cover8];
        
        updateUI()
        
    }
    
    func updateUI()
    {
        
        for i in 0..<covers.count {
            let cover = covers[i]
            
            let album = Album(index : i)
            cover.image = UIImage(named: album.coverImageName!)
        }
    }
    
    
    //MARK : Target / Action
    @IBAction func showAlbum(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "Show Album", sender: sender)

    }
    
    //MARK : Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            switch identifier {
                case "Show Album":
                
                    let albumViewController = segue.destination as! AlbumViewController
                    let albumImageView = (sender as! UITapGestureRecognizer).view as! UIImageView
                    if let index = covers.index(of: albumImageView) {
                        let album = Album(index: index)
                        albumViewController.album = album
                    }
                
                
                default:
                    break
            }
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
