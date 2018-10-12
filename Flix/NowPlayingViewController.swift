//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Vichet Meng on 10/8/18.
//  Copyright © 2018 Vichet Meng. All rights reserved.
//

import UIKit
import AFNetworking

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    var movies:[[String:Any]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchData()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchData()
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
                self.refreshControl.endRefreshing()
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // TODO: Get the array of movies
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    
    // MARK: - TableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieTableViewCell
        let movie = movies[indexPath.row]
        cell.descriptionLabel.text = movie["overview"] as? String
        cell.titleLabel.text = movie["title"] as? String
        let highResImageURLPath = "https://image.tmdb.org/t/p/original" + (movie["poster_path"] as! String)
        let lowResImageURLPath = "https://image.tmdb.org/t/p/w45" + (movie["poster_path"] as! String)
        let highResRequest =  URLRequest(url: URL(string: highResImageURLPath)!)
        let lowResRequest = URLRequest(url: URL(string: lowResImageURLPath)!)
        
        cell.posterImageView.setImageWith(
            lowResRequest,
            placeholderImage: nil,
          success: { (request, respose, smallResImage) in
            cell.posterImageView.alpha = 0.0
            cell.posterImageView.image = smallResImage
            UIView.animate(withDuration: 0.3, animations: {
                cell.posterImageView.alpha = 1
            }, completion: { (success) in
                cell.posterImageView.setImageWith(highResRequest,
                                                  placeholderImage: nil,
                                                  success: { (request, response, highResImage) in
                                                    cell.posterImageView.image = highResImage
                },
                                                  failure: nil)
            })
          },
          failure: nil)
        return cell
    }
    
    // MARK: - SearchBar delegate methods
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        <#code#>
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
