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

    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        fetchData()
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

        cell.titleLabel.text = movie.title
        cell.descriptionLabel.text = movie.description
        cell.posterView.setImageWithURL(movie.thumbnailUrl)

        return cell
    }

    func fetchData() -> Void {
        let apiKey = ""
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=\(apiKey)")!
        let request = NSURLRequest(URL: url)

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)

            if error != nil {
                println(response)
                println(error)
            }
            
            var dict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            var array: Array = dict["movies"] as NSArray
            
            self.movies = array.map({ (m) -> Movie in
                return Movie(
                    title: m["title"] as String,
                    description: m["synopsis"] as String,
                    thumbnailUrl: NSURL(string: m.valueForKeyPath("posters.thumbnail") as String)!
                )
            })

            self.tableView.reloadData()
        }
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
