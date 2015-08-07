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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.detailTableView.dataSource = self
    
    
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
    
    
    
    if (self.selectedTweet?.isRetweet == true) {
      
      detailCell.retweetedByLabel.text = selectedTweet?.username
      
      detailCell.tweetTextLabel.text = selectedTweet?.retweetText
      
      detailCell.userLabel.text = selectedTweet?.retweetedFrom
      
      println(self.selectedTweet?.retweetText)
     
      
    } else {
      detailCell.tweetTextLabel.text = selectedTweet?.text
    }
    
    
    return detailCell
  }
  
  
}
