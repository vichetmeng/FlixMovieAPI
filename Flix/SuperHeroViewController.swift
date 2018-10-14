//
//  SuperHeroViewController.swift
//  Flix
//
//  Created by Vichet Meng on 10/14/18.
//  Copyright © 2018 Vichet Meng. All rights reserved.
//

import UIKit

class SuperHeroViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var movies:[[String:Any]] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    func fetchData() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
                let alertView = UIAlertController(title: "Error", message: "No network connection", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alertView.addAction(dismissAction)
                self.present(alertView,animated: true)
                //self.refreshControl.endRefreshing()
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // TODO: Get the array of movies
                self.movies = dataDictionary["results"] as! [[String:Any]]
                //self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    // MARK: - UICollectionView delegate and datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCollectionViewCell
        let movie = movies[indexPath.item]
        let posterImagePath = movie["poster_path"] as! String
        let posterImageURL = URL(string:"https://image.tmdb.org/t/p/original" + posterImagePath)
        
        cell.posterImage.af_setImage(withURL: posterImageURL!)
        
        return cell
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
