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
    var placeholderImage: UIImage!

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: 320, height: 1000)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.description

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let request = NSURLRequest(URL: movie.originalUrl)
        func success(request: NSURLRequest!, response: NSURLResponse!, image: UIImage!) -> Void {
            println("Success!")
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.posterView.image = image
        }
        func failure(request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void {
            println("Failure :(")
        }
        posterView.setImageWithURLRequest(request, placeholderImage: placeholderImage, success: success, failure: failure)
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
