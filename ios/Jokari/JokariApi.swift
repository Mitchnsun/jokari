//
//  JokariApi.swift
//  Jokari
//
//  Created by Matthieu Comperat on 25/05/2015.
//  Copyright (c) 2015 Matthieu Comperat. All rights reserved.
//

import Foundation

class JokariApi {
  
  // MARK: URLS
  // Development
  let API_URL = "http://localhost:8888/jokari/api"
  // Production
  //let API_URL = "http://www.mcomper.at/jokari/api"

  internal let USERS = "/v1/users"
  
  // MARK: Datas
  func parseJSON(data: NSData) -> NSDictionary {
    var jsonError = NSError?()
    let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
    
    if let unwrappedError = jsonError {
      println("json error: \(unwrappedError)")
    }
    return json
  }
  
  func getErrors(errors: NSArray) -> String {
    var labelErrors = ""
    for err in errors {
      labelErrors += err as! String + " "
    }
    
    return labelErrors
  }
}