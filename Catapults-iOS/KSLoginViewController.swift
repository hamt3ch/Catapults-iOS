//
//  KSLoginViewController.swift
//  Catapults-iOS
//
//  Created by Peyt Spencer Dewar on 3/23/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class KSLoginViewController: UIViewController {
    let readPermissions = ["public_profile", "email", "user_friends"]
    @IBOutlet weak var fbLoginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fbLoginButton.layer.cornerRadius = 5
        fbLoginButton.clipsToBounds = true
    }
    
    /*
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print(FBSDKAccessToken.currentAccessToken())
            self.performSegueWithIdentifier("LoginViewSegue", sender: nil)
        } else {
            print("User needs to log in")
        }
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fbLoginTapped(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(readPermissions, fromViewController: self, handler:{(result, error) -> Void in
        
            //alert messages if not logged in
            if (error != nil || result == nil) {
                //Something went wrong with Facebook. Please try again later!"
                print(error!.localizedDescription)
            } else if (result.isCancelled) {
                print("User cancelled login")
            } else if (!result.declinedPermissions.isEmpty) {
                print("User didn't grant permissions.")
            } else {
                //If User is authenticated and ready to go
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                FirebaseClient.sharedClient.loginWithFacebook(accessToken){(user, error) -> Void in
                if(error != nil){
                   //Something went wrong
                    print("Error: Couldn't Login")
                } else {
                    self.performSegueWithIdentifier("toUsers", sender: nil) // goto UserViewController
                }
            }
//                //bug occurs where segue cannot be performed, uncomment when bug is fixed
//                
//                let usersVC = (self.storyboard?.instantiateViewControllerWithIdentifier("KSUsersViewController"))! as UIViewController
//                let usersNavController = UINavigationController(rootViewController: usersVC)
//                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                appDelegate.window?.rootViewController = usersNavController
            }
            
        })
    }

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /* MARK: - FBSDKLoginButtonDelegate methods
    // To get notifications of login results or logout events assign a delegate to FBSDKLoginButton that confirms to FBSDKLoginButtonDelegate protocol.
    
    in viewDidLoad()
    adding facebook login button to center of view
    loginButton.center = self.view.center;
    self.view.addSubview(loginButton)
    loginButton.readPermissions = ["public_profile", "email", "user_friends"]
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil) {
            print(error.localizedDescription)
        } else {
            //**BUG HERE: doesn't perform segue**//
            self.performSegueWithIdentifier("LoginViewSegue", sender: self)
            print("User logged in. \(result)")
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //**segue works fine here**//
        self.performSegueWithIdentifier("LoginViewSegue", sender: self)
        print("User logged out")
    }
    
    */// END FBSDKLoginButtonDelegate methods

}
