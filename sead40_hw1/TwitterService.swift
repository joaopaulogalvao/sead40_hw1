//
//  TwitterService.swift
//  sead40_hw1
//
//  Created by Joao Paulo Galvao Alves on 8/5/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import Foundation
import Accounts
import Social

class TwitterService {
  
  static let sharedService = TwitterService()
  
  var account: ACAccount?
  
  private init() {}
  
  // Function that access
  class func tweetsFromHomeTimeline(completionHandler : (String?, [Tweet]?) -> (Void)) {
    
    //Create a request object to Twitter's server / JSON File in the server is the same as local one used on previous example
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!, parameters: nil)
    
    //User the account information to authenticate
    request.account = self.sharedService.account
    
    //Perform an asynchornous request
    request.performRequestWithHandler { (data , response, error) -> Void in
      if let error = error {
        completionHandler("could not connect to the server", nil)
      } else {
        println(response.statusCode)
        switch response.statusCode {
        case 200...299:
          let tweets = TweetJSONParser.tweetsFromJSONData(data)
          completionHandler(nil,tweets)
        case 400...499:
          completionHandler("this is our fault", nil)
        case 500...599:
          completionHandler("this is the servers fault", nil)
        default:
          completionHandler("error occurred", nil)
        }
      }
    }
  }
}

