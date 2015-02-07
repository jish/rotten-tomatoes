//
//  MovieDetailViewController.swift
//  rotten-tomatoes
//
//  Created by Josh Lubaway on 2/5/15.
//  Copyright (c) 2015 Frustrated Inc. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie: Movie!

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.description
        posterView.setImageWithURL(movie.originalUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
