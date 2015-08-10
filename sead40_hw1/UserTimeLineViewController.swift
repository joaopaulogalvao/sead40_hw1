//
//  UserTimeLineViewController.swift
//  sead40_hw1
//
//  Created by Joao Paulo Galvao Alves on 8/7/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import UIKit
import Accounts
import Social

class UserTimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var tweets = [Tweet]()
  var selectedScreenName : Tweet?
  var screen_name : String?
  var id : String?
  
  lazy var userImageQueue = NSOperationQueue()
  
  @IBOutlet weak var userTimeLineView: UIView!
  @IBOutlet weak var userTimeLineLabel: UILabel!
  @IBOutlet weak var userTimeLineUsername: UILabel!
  @IBOutlet weak var userTimeLineText: UILabel!
  @IBOutlet weak var userTimeLineImageView: UIImageView!
  
  @IBOutlet weak var userTimeLineViewTableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // Remove the label text
      self.userTimeLineLabel.text = ""
      self.userTimeLineUsername.text = ""
      self.userTimeLineText.text = ""
      
      let nibName = UINib(nibName: "TweetCellTemplate", bundle:nil)
      
      self.userTimeLineViewTableView.registerNib(nibName, forCellReuseIdentifier: "DetailCell")
      
//      if let userViewCell = NSBundle.mainBundle().loadNibNamed("TweetCellTemplate", owner: self, options: nil).first as? DetailCell {
//        view.addSubview(userViewCell)
//      }
      self.userTimeLineLabel.text = self.selectedScreenName?.userAddress
      
      self.view.constraints()
      self.userTimeLineViewTableView.delegate = self
      self.userTimeLineViewTableView.dataSource = self
      
      
        // Do any additional setup after loading the view
      // Access the TwitterService - Handler: After access an account check for error and tweets
      TwitterService.tweetsFromUserTimeLine( screen_name!,id: id!, completionHandler: { (errorDescription, tweets) -> (Void) in
        //After checking - If I had left just a println(tweets) without setting a switch case in my TwitterService it would have returned a code 200. As anything else other than an error would return any code. I hadn't done the else and the switch case inside it by that moment.
        println(self.id)
        //Handle existing tweets
        if let tweets = tweets {
          
          //Send tweets to the mainQueue/Thread
          
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.tweets = tweets
            self.userTimeLineLabel.text = self.selectedScreenName?.username
            self.userTimeLineUsername.text = self.selectedScreenName?.userAddress
            self.userTimeLineText.text = self.selectedScreenName?.text
            self.userTimeLineImageView.image = self.selectedScreenName?.profileImage
            
            self.userTimeLineViewTableView.estimatedRowHeight = 100
            self.userTimeLineViewTableView.rowHeight = UITableViewAutomaticDimension
            self.userTimeLineViewTableView.reloadData()
            
          })
        }
      })
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

    // MARK: - UITableViewDataSource
extension UserTimeLineViewController : UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    let userCell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailCell
    
    userCell.tag++
    let tag = userCell.tag
    
    var tweetsFromUser = self.tweets[indexPath.row]
    
    userCell.retweetedByLabel.hidden = true
    userCell.retweetedByText.hidden = true
    userCell.userLabel.hidden = true
    userCell.userAddress.hidden = true
    //userCell.retweetedBtnImg.hidden = true
    
    userCell.tweetTextLabel.text = tweetsFromUser.text
    
    if let profileImage = self.selectedScreenName?.profileImage {
      
      userCell.retweetedBtnImg.setBackgroundImage(profileImage, forState: UIControlState.Normal)
      
      
    } else {
      
      
      //Only load when needed
      userImageQueue.addOperationWithBlock({ () -> Void in
        //Check if there is an URL, Data and image
        if let imageURL = NSURL(string: self.selectedScreenName!.profileImageURL),
          data = NSData(contentsOfURL: imageURL),
          image = UIImage(data: data){
            
            //Check for image size depending on resolution
            var size : CGSize
            switch UIScreen.mainScreen().scale {
            case 2:
              size = CGSize(width: 160, height: 160)
            case 3:
              size = CGSize(width: 240, height: 240)
              println("Size 240")
            default:
              size = CGSize(width: 80, height: 80)
              println("default")
            }
            
            let resizedImage = ImageSizer.resizeImage(image, size: size)
            
            // Send operation back to the main Queue
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              tweetsFromUser.profileImage = resizedImage
              self.tweets[indexPath.row] = tweetsFromUser
              if userCell.tag == tag {
                userCell.retweetedBtnImg.imageView?.image = resizedImage
              }
            })
            
        }
      })
      
    }
    
    
    println(userCell.userLabel.text)
    
    return userCell
  }
}





