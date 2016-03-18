//
//  CATextViewController.swift
//  Catapults-iOS
//
//  Created by Hugh A. Miles II on 3/9/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit
import SlackTextViewController

class KSTextViewController: SLKTextViewController, PubNubChatDelegate {
    
    var messages: [String]?
    var currentChannel: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentChannel
        
        PubNubClient.sharedClient.subscribeTo(currentChannel!) //subscribe to currentChannel selected
        
        self.setupController()
        PubNubClient.sharedClient.chatDelegate = self
        let response = PubNubClient.sharedClient.getMessages(currentChannel!)
        //messages = response[0] // messagesString is first index in respons from client
        
        // Do any additional setup after loading the view.
 
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SLKTextViewController
    
    override func didPressLeftButton(sender: AnyObject!) {
        
    }
    
    
    //when Send button is pressed
    override func didPressRightButton(sender: AnyObject!) {
        self.textView.refreshFirstResponder()
        let messageBody = self.textView.text.copy() as! String
        
        //let username = "\(User.currentUser!.firstName!) \(User.currentUser!.lastName!)"
        let username = "Hugh"
        
        //getDate
        let date: String?
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a" //3:30 PM
        let strDate = dateFormatter.stringFromDate(NSDate())  //getCurrentDate
        date = strDate
        
        //Send Message thru ChatClient
        PubNubClient.sharedClient.sendMessage(messageBody,sendTo: currentChannel!)

        self.tableView.slk_scrollToBottomAnimated(true)
        super.didPressRightButton(sender)
    }
    
    //MARK: - UITableViewSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil {
            return (messages?.count)!
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KSMessageTVCell", forIndexPath: indexPath) as! KSMessageCell
        cell.transform = self.tableView.transform
        
        let message = messages![indexPath.row]
        
        cell.bodyLabel.text = message
        
        return cell
    }

    //MARK: - Setup Texting
    func setupController () {
        //Setup bottom bar
        self.textView.placeholder = "Message" //place to send text located at the bottom
        self.textView.placeholderColor = UIColor.lightGrayColor()
        self.leftButton.tintColor = UIColor.grayColor()
        self.rightButton.setTitle("Send", forState: UIControlState.Normal)
        self.textInputbar.autoHideRightButton = true
        self.textInputbar.maxCharCount = 140
        self.textInputbar.counterStyle = SLKCounterStyle.Split
        self.typingIndicatorView.canResignByTouch = true
        inverted = true
        
        self.bounces = true
        self.shakeToClearEnabled = true
        self.keyboardPanningEnabled = true
        
        //register a nib when xib files are used to create custom views
        let nibReq = UINib(nibName: "KSMessageCell", bundle: nil)
        tableView.registerNib(nibReq, forCellReuseIdentifier: "KSMessageTVCell")
        tableView.rowHeight = UITableViewAutomaticDimension //needed for autolayout
        tableView.estimatedRowHeight = 70.0 //needed for autolayout
    }
    
    
    //MARK: - PUBNUB Chat Delegate
    func getAllMessagesCompletion(messagesRecieved: [String]?) {
        self.messages = messagesRecieved?.reverse()
        self.tableView.reloadData()
    }
    
    func didRecieveMessageCompletion(messageRecived: String) {
        addRowToTableview(messageRecived) //append newMessage from callback
    }
    
    //MARK: - Helpers
    func addRowToTableview(message:String){ //add new message to tableView
        self.messages?.insert(message, atIndex: 0) //add to top
        tableView.beginUpdates() //start update
        let toAdd = NSIndexPath(forRow: 0, inSection: 0) //becuase of slackTextController new text is added to the top of array (stack)
        tableView.insertRowsAtIndexPaths([toAdd], withRowAnimation: .Top) // insert new cell
        tableView.endUpdates() //end update
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
