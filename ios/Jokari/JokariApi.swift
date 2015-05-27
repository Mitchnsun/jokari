//
//  JokariApi.swift
//  Jokari
//
//  Created by Matthieu Comperat on 25/05/2015.
//  Copyright (c) 2015 Matthieu Comperat. All rights reserved.
//

import Foundation

class JokariApi {
  
  // Development
  let API_URL = "http://localhost:8888/jokari/api"
  // Production
  //let API_URL = "http://www.mcomper.at/jokari/api"
  
  // API Data
  internal let USERS = "/v1/users"
  
  private func formatURL(data: String) -> String{
    var url : String = self.API_URL + data
    return url
  }
  
  func getRequest(httpMethod: String, data: String) -> NSMutableURLRequest{
    var request : NSMutableURLRequest = NSMutableURLRequest()
    request.URL = NSURL(string: self.formatURL(data))
    request.HTTPMethod = httpMethod
    
    println("Request \(request.HTTPMethod)")
    
    return request
  }
}