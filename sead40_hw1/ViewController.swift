//
//  ViewController.swift
//  sead40_hw1
//
//  Created by Joao Paulo Galvao Alves on 8/4/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableview: UITableView!
  
  var tweets = [Tweet]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
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
        
        // Access the TwitterService - Handler: After access an account check for error and tweets
        TwitterService.tweetsFromHomeTimeline(account, completionHandler: { (errorDescription, tweets) -> (Void) in
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
    
    tableview.dataSource = self
    tableview.reloadData()
    
    
    
    
    
    
    
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

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

//MARK: UITableViewDataSource
extension ViewController : UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
    
    // Fetch an array of Tweets to an index
    let tweet = tweets[indexPath.row]
    
    //Place username in its label
    cell.usernameLabel.text = tweet.username
    
    return cell
  }
}






















