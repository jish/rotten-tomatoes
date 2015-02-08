//
//  MoviesViewController.swift
//  rotten-tomatoes
//
//  Created by Josh Lubaway on 2/2/15.
//  Copyright (c) 2015 Frustrated Inc. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var banner: UIView!

    var movies: [Movie] = []
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh:", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.delegate = self
        tableView.dataSource = self

        fetchData(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movie-cell") as MovieTableViewCell
        let movie = movies[indexPath.row]

        cell.audienceScoreLabel.text = "\(movie.audienceScore)%"
        cell.titleLabel.text = movie.title
        cell.descriptionLabel.text = movie.description
        cell.posterView.setImageWithURL(movie.thumbnailUrl)

        return cell
    }

    func fetchData(showLoadingSpinner: Bool) -> Void {
        let apiKey = ""
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=\(apiKey)")!
        let request = NSURLRequest(URL: url)

        banner.hidden = true
        
        if showLoadingSpinner {
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.refreshControl.endRefreshing()

            if error != nil {
                self.displayError(error.localizedDescription)
                return
            }

            var dict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary

            let httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 403 {
                let message = dict["error"] as String
                self.displayError("\(message). Plase provide a valid API key.")
            }

            var array: Array = dict["movies"] as NSArray

            self.movies = array.map({ (m) -> Movie in
                return Movie(
                    audienceScore: m.valueForKeyPath("ratings.audience_score") as Int,
                    criticScore: m.valueForKeyPath("ratings.critics_score") as Int,
                    title: m["title"] as String,
                    description: m["synopsis"] as String,
                    thumbnailUrl: NSURL(string: m.valueForKeyPath("posters.thumbnail") as String)!
                )
            })

            self.movies = sorted(self.movies) { $0.audienceScore > $1.audienceScore }

            self.tableView.reloadData()
        }
    }

    func displayError(message: String) {
        println(message)
        banner.hidden = false
    }

    func onRefresh(sender: AnyObject) {
        fetchData(false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as MovieDetailViewController

        if let indexPath = tableView.indexPathForSelectedRow() {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as MovieTableViewCell
            controller.movie = movies[indexPath.row]
            controller.placeholderImage = cell.posterView.image
        } else {
            println("prepareForSegue: Count not find indexPathForSelectedRow")
        }
    }

}
