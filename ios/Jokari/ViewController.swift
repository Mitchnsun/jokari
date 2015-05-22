//
//  ViewController.swift
//  Jokari
//
//  Created by Matthieu Comperat on 15/05/2015.
//  Copyright (c) 2015 Matthieu Comperat. All rights reserved.
//

import UIKit

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
                let FB_Email : String = result.valueForKey("email") as! String
                self.Email.text = FB_Email
                let FB_Name : String = result.valueForKey("name") as! String
                self.FBName.text = FB_Name
                let FB_FirstName : String = result.valueForKey("first_name") as! String
                self.FirstName.text = FB_FirstName
                let FB_LastName : String = result.valueForKey("last_name") as! String
                self.LastName.text = FB_LastName
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
                let UrlProfilPic : String = data.valueForKey("url") as! String
                let url : NSURL = NSURL(string: UrlProfilPic)!
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