//
//  Tweet.swift
//  sead40_hw1
//
//  Created by Joao Paulo Galvao Alves on 8/4/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import Foundation

struct Tweet {
  
  let text : String?
  let username : String
  let id : String
  let profileImageURL : String
  var retweet : [String : AnyObject]?
  var quotedTweet : [String : AnyObject]?
  
}


