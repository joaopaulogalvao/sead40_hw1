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
      
      // Check for all JSON's parameters - only check for retweet if all others are checked, otherwise if it is not a retweet the check will fail
      for tweetObject in rootObject {
        if let text = tweetObject["text"] as? String,
          id = tweetObject["id_str"] as? String,
          userInfo = tweetObject["user"] as? [String : AnyObject], // Uses it to access the value for the key user
          username = userInfo["name"] as? String,
        profileImageURL = userInfo["profile_image_url"] as? String {
          
          //If they exist, create a tweet object with retweet as nil, for the compiler, as the Struct contains it
          var tweet = Tweet(text: text, username: username, id: id, profileImageURL: profileImageURL, retweet: nil, quotedTweet: nil )
          
          //Check if it is a retweet
          if let retweetDict = tweetObject["retweeted_status"] as? [String : AnyObject] {
            
              //Change the retweet parameter to the value which was found
              tweet.retweet = retweetDict
              println("It is a retweet")
              //println(tweetObject["retweeted_status"])
            }
          
          //Check if it is a quote
          if let quoteTweetDict = tweetObject["quoted_status"] as? [String : AnyObject] {
            
              //Change the quoteTweet parameter to the value which was found
              tweet.quotedTweet = quoteTweetDict
              println("It is a Quote")
          }
          
            // Append a tweet
            tweets.append(tweet)
            
        }
      }
      return tweets
    }
    return nil
  }
}
