//
//  ViewController.swift
//  Catapults-iOS
//
//  Created by Hugh A. Miles II on 3/9/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var chatClient = PubNubClient() // instantiate pubNub Client for chat

    @IBOutlet weak var inputTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendBtnPressed(sender: AnyObject) {

    }

}

