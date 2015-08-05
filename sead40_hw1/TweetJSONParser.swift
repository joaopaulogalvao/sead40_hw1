//
//  TweetJSONParser.swift
//  sead40_hw1
//
//  Created by Joao Paulo Galvao Alves on 8/4/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import Foundation

class TweetJSONParser {
  class func tweetsFromJSONData (jsonData : NSData) -> [Tweet]? {
    
    var error : NSError?
    
    if let rootObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as? [[String : AnyObject]]
    {
      var tweets = [Tweet]()
      for tweetObject in rootObject {
        if let text = tweetObject["text"] as? String,
          id = tweetObject["id_str"] as? String,
          userInfo = tweetObject["user"] as? [String : AnyObject], // Uses it to access the value for the key user
          username = userInfo["name"] as? String,
          profileImageURL = userInfo["profile_image_url"] as? String {
            let tweet = Tweet(text: text, username: username, id: id, profileImageURL: profileImageURL)
            tweets.append(tweet)
        }
      }
      return tweets
    }
    return nil
  }
}
