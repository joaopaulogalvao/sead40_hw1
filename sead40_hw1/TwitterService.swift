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
  class func tweetsFromHomeTimeline(account : ACAccount, completionHandler : (String?, [Tweet]?) -> (Void)) {
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!, parameters: nil)
    request.account = account
    
    request.performRequestWithHandler { (data , response, error) -> Void in
      if let error = error {
        completionHandler("could not connect to the server", nil)
      } else {
        println(response.statusCode)
      }
    }
  }
}

