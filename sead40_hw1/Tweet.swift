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
  let author : String
  let username : String
  let id : String
  let profileImageURL : String

}

let tweet = Tweet(text: "This is my first tweet.", author: "Joao", username: "jalves", id: "00001", profileImageURL: "myImage.jpg")