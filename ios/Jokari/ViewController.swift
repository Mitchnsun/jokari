//
//  ViewController.swift
//  Jokari
//
//  Created by Matthieu Comperat on 15/05/2015.
//  Copyright (c) 2015 Matthieu Comperat. All rights reserved.
//

import UIKit
import SwiftHTTP

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
  
  @IBOutlet weak var FBLoginView: FBSDKLoginButton!
  @IBOutlet weak var Email: UITextField!
  @IBOutlet weak var Pseudo: UITextField!
  @IBOutlet weak var Password: UITextField!
  @IBOutlet weak var FirstName: UITextField!
  @IBOutlet weak var LastName: UITextField!
  @IBOutlet weak var SubmitButton: UIButton!
  @IBOutlet weak var ProfilePicture: UIImageView!
  @IBOutlet weak var FBName: UILabel!
  
  var FB_user : NSMutableDictionary = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    FBLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    FBLoginView.delegate = self
    
    if (FBSDKAccessToken.currentAccessToken() != nil) {
      // User is already logged in, do work such as go to next view controller.
      
      // Or Show Logout Button
      FBLoginView.hidden = true
      ProfilePicture.hidden = false
      FBName.hidden = false
      self.returnUserData()
    } else {
      FBLoginView.hidden = false
    }
    
  }
  
  // MARK: Submit Actions
  @IBAction func submit(sender: UIButton) {
    self.SubmitButton.enabled = false
    var request = HTTPTask()
    request.baseURL = JokariApi().API_URL
    let params: Dictionary<String,AnyObject> = [
      "firstname" : self.FirstName.text,
      "lastname" : self.LastName.text,
      "email" : self.Email.text,
      "pseudo" : self.Pseudo.text,
      "password" : self.Password.text,
      "FB_user" : self.FB_user
    ]
    request.POST(JokariApi().USERS, parameters: params, completionHandler: {(response: HTTPResponse) in
      self.SubmitButton.enabled = true
      if let err = response.error {
        println("error: \(err)")
        return //also notify app of failure as needed
      }
      if let data = response.responseObject as? NSData {
        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("response: \(str)") //prints the HTML of the page
      }
    })
  }
  
  // MARK: Facebook Delegate Methods
  
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    println("User Logged In")
    
    if ((error) != nil)
    {
      // Process error
    }
    else if result.isCancelled {
      // Handle cancellations
    }
    else {
      // If you ask for multiple permissions at once, you
      // should check if specific permissions missing
      if result.grantedPermissions.contains("email")
      {
        // Do work
      }
      
      FBLoginView.hidden = true
      ProfilePicture.hidden = false
      FBName.hidden = false
      self.returnUserData()
    }
    
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    self.Email.text = ""
    self.FirstName.text = ""
    self.LastName.text = ""
    ProfilePicture.hidden = true
    FBName.hidden = true
  }
  
  func returnUserData()
  {
    let userRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    let pictureRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/picture?redirect=false&type=large", parameters: nil)
    let graphConnection = FBSDKGraphRequestConnection()
    graphConnection.addRequest(userRequest, completionHandler: { (connection, result, error) -> Void in
      
      if ((error) != nil)
      {
        // Process error
        println("Error: \(error)")
      }
      else
      {
        println("fetched user: \(result)")
        self.FB_user = result.mutableCopy() as! NSMutableDictionary
        self.Email.text = self.FB_user.valueForKey("email") as! String
        self.FBName.text = self.FB_user.valueForKey("name") as? String
        self.FirstName.text = self.FB_user.valueForKey("first_name") as! String
        self.LastName.text = self.FB_user.valueForKey("last_name") as! String
      }
    })
    graphConnection.addRequest(pictureRequest, completionHandler: { (connection, result, error) -> Void in
      
      if ((error) != nil)
      {
        // Process error
        println("Error: \(error)")
      }
      else
      {
        let data : NSDictionary = result.valueForKey("data") as! NSDictionary;
        let UrlProfilePic : String = data.valueForKey("url") as! String
        let url : NSURL = NSURL(string: UrlProfilePic)!
        self.FB_user.setValue(url, forKey: "url_profilepic")
        let PicData : NSData = NSData(contentsOfURL: url)!
        var picture : UIImage = UIImage(data: PicData)!
        self.ProfilePicture.image = picture
        println("fetched user: \(data)")
      }
    })
    graphConnection.start()
  }
  
  // MARK: UIViewController delegate methods
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}