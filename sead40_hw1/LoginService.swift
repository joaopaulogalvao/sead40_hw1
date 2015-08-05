//
//  LoginService.swift
//  sead40_hw1
//
//  Created by Joao Paulo Galvao Alves on 8/5/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import Foundation
import Accounts

class LoginService {
  class func loginForTwitter (completionHandler: (String?, ACAccount?) -> (Void)) {
    
    // Creates an account object which accesses Accounts stored in Twitter's database
    let accountStore = ACAccountStore()
    
    // Identify what is the account type(Twitter, FB, Weibo, etc)
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    
    // Request to access User's Twitter Account
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
      // Handle errors with the completionHandler
      if let error = error {
        
        //println("Please, Sign in!") - Use a handler
        
        // If error, run this with the completionHandler which uses two parameters
        completionHandler("Please, Sign in", nil)
        
      // Handle access
      } else {
        
        // Handle granted access
        if granted {
          
          //println("Granted") - Use a handler
          
          // Optional bind - check if its type is correct and if there is an account get the first one
          if let account = accountStore.accountsWithAccountType(accountType).first as? ACAccount {
            
            //Everything is ok, get the account
            completionHandler(nil,account)
            
          }
          
        // Handle rejected access
        } else {
          
          // Tell the user this app needs Twitter
          completionHandler("This app requires Twitter access",nil)
          
        }
      }
    }
  }
}


