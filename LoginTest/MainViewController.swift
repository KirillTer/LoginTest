//
//  MainViewController.swift
//  LoginTest
//
//  Created by Kirill on 1/31/17.
//  Copyright © 2017 KirillTer. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    var data:[String:AnyObject] = [:]
    var friendsNamesArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 108, y: 90, width: 100, height: 30)
        
        print(self.data["first_name"]!)
        print(self.data["email"]!)
        let friends = self.data["taggable_friends"]!
        
        let resultdict = friends as! NSDictionary
        let data : NSArray = resultdict.object(forKey: "data") as! NSArray
        
        for i in 0..<data.count {
            let valueDict : NSDictionary = data[i] as! NSDictionary
            let name = valueDict.object(forKey: "name") as! String
            self.friendsNamesArray.append(name)
        }
        
        let picture = self.data["picture"] as! NSDictionary, datapic = picture["data"] as! NSDictionary, url = datapic["url"] as! String
        print(url)
            
        self.profileNameLabel.text = self.data["first_name"]! as? String
        
        if let checkedUrl = URL(string: url) {
            self.profileImage.contentMode = .scaleAspectFit
            self.downloadImage(url: checkedUrl)
        }
        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
    }
    
    //Logout method
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let previous = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(previous, animated: true, completion: nil)
        print("Did log out of facebook")
    }
    
    //Download image
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.profileImage.image = UIImage(data: data)
            }
        }
    }
    
    //Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell?.textLabel?.text = self.friendsNamesArray[indexPath.row]
        return cell!
    }

}
