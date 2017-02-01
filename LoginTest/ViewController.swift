//
//  ViewController.swift
//  LoginTest
//
//  Created by Admin on 11/22/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 70, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        
        if FBSDKAccessToken.current() == nil {
            featchProfile()
        }
    }
    
    func featchProfile() {
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large), taggable_friends"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            }
            else {
                let data = result as! [String : AnyObject]
                print(data["first_name"]!)
                print(data["email"]!)
                
                let next = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                next.data = data
                self.present(next, animated: true, completion: nil)
            }
        })
        print("Successfully featchProfile")
    }
    
    //FBSDKLoginButtonDelegate methods
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let previous = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(previous, animated: true, completion: nil)
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        featchProfile()
        print("Successfully logged in with facebook...")
    }
}

