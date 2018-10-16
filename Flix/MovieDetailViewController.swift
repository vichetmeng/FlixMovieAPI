//
//  MovieDetailViewController.swift
//  Flix
//
//  Created by Vichet Meng on 10/14/18.
//  Copyright © 2018 Vichet Meng. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie:[String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            
            titleLabel.text = movie["title"] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            overviewLabel.sizeToFit()
            let posterImagePath = movie["poster_path"] as? String
            let backDropImagePath = movie["backdrop_path"] as? String
            let basePath = "https://image.tmdb.org/t/p/original"
            let posterURL = URL(string:basePath + posterImagePath!)!
            let backDropURL = URL(string:basePath + backDropImagePath!)!
            backDropImage.af_setImage(withURL: backDropURL)
            posterImage.af_setImage(withURL: posterURL)
            
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifer = segue.identifier {
            switch(identifer) {
            case "ShowTrailer":
                if let dvc = segue.destination as? MovieTrailerViewController {
                    if let movie = movie {
                        let id = movie["id"] as? Int
                        dvc.movieId = id
                        print(id!)
                    }
                }
            default:
                break
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
