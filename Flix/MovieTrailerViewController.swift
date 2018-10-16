//
//  MovieTrailerViewController.swift
//  Flix
//
//  Created by Vichet Meng on 10/15/18.
//  Copyright © 2018 Vichet Meng. All rights reserved.
//

import UIKit
import WebKit

class MovieTrailerViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var movieId: Int?
    var videoUrl: URL? {
        didSet {
            let urlRequest = URLRequest(url: videoUrl!)
            webView.load(urlRequest)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        print("loading trailer")
        // Do any additional setup after loading the view.
    }
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchData() {
        let urlStr = "https://api.themoviedb.org/3/movie/\(movieId!)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        print(urlStr)
        let url = URL(string: urlStr)!
        
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
                
                let results = dataDictionary["results"] as! [[String:Any]]
                let result = results[0]
                let pathURL = "https://www.youtube.com/embed/\(result["key"]!)"
                print("pathURL: " + pathURL)
                self.videoUrl = URL(string:pathURL)!
            }
        }
        task.resume()
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
