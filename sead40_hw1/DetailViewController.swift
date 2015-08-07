//
//  DetailViewController.swift
//  sead40_hw1
//
//  Created by Joao Paulo Galvao Alves on 8/6/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var detailTableView: UITableView!
  
  
  var selectedTweet : Tweet?
  lazy var retweetImageQueue = NSOperationQueue()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.detailTableView.dataSource = self
    self.detailTableView.delegate = self
    
    detailTableView.estimatedRowHeight = 100
    detailTableView.rowHeight = UITableViewAutomaticDimension
    
    self.detailTableView.reloadData()
    self.view.constraints()
    // Do any additional setup after loading the view.
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


extension DetailViewController : UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let detailCell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! DetailCell
    
    
    // If it is a retweet, show its infos
    if (self.selectedTweet?.isRetweet == true) {
      detailCell.retweetedImgView.image = nil
      
      detailCell.retweetedByLabel.text = selectedTweet?.username
      
      detailCell.tweetTextLabel.text = selectedTweet?.retweetText
      
      detailCell.userLabel.text = selectedTweet?.retweetedFrom
      detailCell.userLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
      
      detailCell.userAddress.text = selectedTweet?.retweetedUserAddress
      
      println(self.selectedTweet?.retweetText)
      
      if let profileImage = self.selectedTweet?.profileImage {
        
        detailCell.retweetedImgView.image = profileImage
        
      } else {
        //Only load when needed
        retweetImageQueue.addOperationWithBlock({ () -> Void in
          //Check if there is an URL, Data and image
          if let imageURL = NSURL(string: self.selectedTweet!.profileImageURL),
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
              
              
          }
          
          
        })
      }
     
    // If it is a quote, show its infos
    } else if (self.selectedTweet?.isQuote == true){
      
      detailCell.tweetTextLabel.text = selectedTweet?.quoteText
      
    // If it is a normal tweet, show its infos
    } else {
      detailCell.retweetedByLabel.hidden = true
     detailCell.retweetedByText.hidden = true
      detailCell.tweetTextLabel.text = selectedTweet?.text
      detailCell.userLabel.text = selectedTweet?.username
      detailCell.userAddress.text = selectedTweet?.userAddress
    }
    
    
    return detailCell
  }
  
  
}
