//
//  ViewController.swift
//  sead40_hw1
//
//  Created by Joao Paulo Galvao Alves on 8/4/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableview: UITableView!
  
  var tweets = [Tweet]()
  var refreshControl : UIRefreshControl!
  lazy var imageQueue = NSOperationQueue()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.tableview.addSubview(refreshControl)
    
  
    tableview.estimatedRowHeight = 100
    tableview.rowHeight = UITableViewAutomaticDimension
    
    
    /* Access the LoginService and alert for errors after the view is loaded
    
       There are two parameters being used in the closure: errorDescription(String) and account(ACAccount) - this call will handle errors and account access*/
    
    LoginService.loginForTwitter { (errorDescription, account) -> (Void) in
      
      // Handle errors
      if let errorDescription = errorDescription {
        // alert the user
      } else {
        println("No errors")
      }
      
      // Handle access - If theres is an account fetch an account and handle it asynchronously by using the function tweetsfromHomeTimeline
      if let account = account {
        
        //Get the account reference from the twitter service
        TwitterService.sharedService.account = account
        
        // Access the TwitterService - Handler: After access an account check for error and tweets
        TwitterService.tweetsFromHomeTimeline({ (errorDescription, tweets) -> (Void) in
          //After checking - If I had left just a println(tweets) without setting a switch case in my TwitterService it would have returned a code 200. As anything else other than an error would return any code. I hadn't done the else and the switch case inside it by that moment.
            //println(tweets)
          
          //Handle existing tweets
          if let tweets = tweets {
            
            //Send tweets to the mainQueue/Thread
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              self.tweets = tweets
              self.tableview.reloadData()
            })
          }
        })
      }
    }
    
    self.view.constraints()
    
    tableview.dataSource = self
    tableview.delegate = self
    tableview.reloadData()
    

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLabels", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    

//    if let filepath = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
//      if let data = NSData(contentsOfFile: filepath) {
//        if let tweets = TweetJSONParser.tweetsFromJSONData(data) {
//          self.tweets = tweets
//          
//          //println(tweets)
//          //println(LoginService.loginForTwitter(<#completionHandler: (String?, ACAccount?) -> Void##(String?, ACAccount?) -> Void#>))
//        }
//      }
//    }
  }
  
  func refresh(sender: AnyObject){

      
      // Access the TwitterService - Handler: After access an account check for error and tweets
      TwitterService.tweetsFromHomeTimeline({ (errorDescription, tweets) -> (Void) in
        //After checking - If I had left just a println(tweets) without setting a switch case in my TwitterService it would have returned a code 200. As anything else other than an error would return any code. I hadn't done the else and the switch case inside it by that moment.
        //println(tweets)
        
        //Handle existing tweets
        if let tweets = tweets {
          
          //Send tweets to the mainQueue/Thread
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.tweets = tweets
            self.tableview.reloadData()
            self.refreshControl.endRefreshing()
          })
        }
      })
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    
  }
  
  func updateLabels() {
    
    self.tableview.reloadData()

    
  }


}

//MARK: UITableViewDataSource
extension ViewController : UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
    
    cell.tag++
    let tag = cell.tag
    
    // Fetch an array of Tweets to an index
    var tweet = tweets[indexPath.row]
    
    //Fetch images
    cell.profileImageView.image = nil
    
    //Place username in its label
    cell.usernameLabel.text = tweet.username
    cell.usernameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    
    cell.tweetLabel.text = tweet.text
    
    //Check if there is an image
    if let profileImage = tweet.profileImage {
      
      cell.profileImageView.image = profileImage
      
    } else {
      //Only load when needed
      imageQueue.addOperationWithBlock({ () -> Void in
        //Check if there is an URL, Data and image
        if let imageURL = NSURL(string: tweet.profileImageURL),
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
              tweet.profileImage = resizedImage
              self.tweets[indexPath.row] = tweet
              if cell.tag == tag {
                cell.profileImageView.image = resizedImage
              }
            })
          
        }
        
        
      })
    }
    
    return cell
  }
  
  //MARK: Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
    if segue.identifier == "ShowDetailTweet" {
      if let detailViewController = segue.destinationViewController as? DetailViewController {
        
        let myIndexPath = self.tableview.indexPathForSelectedRow()
        
        if let indexPath = self.tableview.indexPathForSelectedRow() {
          
          let selectedRow = indexPath.row
          let selectedTweet = self.tweets[selectedRow]
          println("Row \(indexPath.row) selected")
          
          
          detailViewController.selectedTweet = selectedTweet
          
        }
        
        println("Detail Clicked")
        
      }
    }
  }
}



























