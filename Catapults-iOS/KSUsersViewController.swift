//
//  KSUsersViewController.swift
//  Catapults-iOS
//
//  Created by Hugh A. Miles II on 3/10/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit

class KSUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var channel = [String]() //User Channels
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Getting users...\(User.currentUser)")
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        FirebaseClient.sharedClient.getUsers() { (usernames, error) -> Void in
            if(error == nil){
                self.channel = usernames!
                self.usersTableView.reloadData()
            } else {
                print("couldnt get Users")
            }
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        PubNubClient.sharedClient.unsubscribeFrom("All") //unsubscribe from allChannels   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutTapped(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    //MARK: - UITableView DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return channel.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! KSUserTableViewCell
        
        cell.usernameLabel.text = channel[indexPath.row]
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! KSUserTableViewCell //cast sender >> UICollectionCell
        let index = self.usersTableView.indexPathForCell(cell) //GetIndex that was selected
        let selectedUser = self.channel[index!.row] // getMovie from dictionary
        
        let detail = segue.destinationViewController as! KSTextViewController
        detail.currentChannel = selectedUser
        

    }

}
