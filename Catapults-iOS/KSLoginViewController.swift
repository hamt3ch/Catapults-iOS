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

    override func viewDidLoad() {
        super.viewDidLoad()

        //adding facebook login button to center of view
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center;
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
