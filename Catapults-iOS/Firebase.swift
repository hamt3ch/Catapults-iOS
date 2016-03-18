//
//  Firebase.swift
//  KickSwap
//
//  Created by Hugh A. Miles II on 2/17/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import Firebase

protocol FirebaseLoginDelegate: class {
    func loginCompletion() -> Void
    func loginFailure(error: NSError?) -> Void
}

protocol FirebaseUserDelegate: class {
    func getUsersCompletion(users: [String:NSObject]) -> Void
}

typealias StringErrorCompletionBlock = ([String]?, NSError?) -> Void

class FirebaseClient: NSObject {
    
    static let sharedClient = FirebaseClient()
    static let baseURL = "https://kickswap.firebaseio.com"
    
    weak var loginDelegate: FirebaseLoginDelegate?
    weak var userDelegate: FirebaseUserDelegate?
    
    private class myURIs{
        //auth related calls
        static let users = "users"
        static let shoes = "shoes"
    }
    
    private func getRef() -> AnyObject {
        return Firebase(url: FirebaseClient.baseURL)
    }
    
    private func getUserRef() -> AnyObject {
        return Firebase(url: "\(FirebaseClient.baseURL)/\(myURIs.users)")
    }
    
    private func getRefWith(child:String) -> AnyObject {
        return Firebase(url: "\(FirebaseClient.baseURL)/\(child)")
    }
    
    /* Login w/ Facebook
        - Register user into Firebase DB with FacebookID
    */
    
    func loginWithFacebook(fbAccessToken:String) {
        //Authenticate with facebookID
        FirebaseClient.sharedClient.getRef().authWithOAuthProvider("facebook", token: fbAccessToken,
            withCompletionBlock: { error, authData in
                if error != nil {
                    print("Login failed. \(error)")
                    self.loginDelegate?.loginFailure(error)
                } else {
                    //set global currentUser
                    let newUser = User(data: authData)
                    User.currentUser = newUser
                    
                    //set value back into Firebase
                    // FirebaseClient.saveUser(User.currentUser!)
                    self.loginDelegate?.loginCompletion()
                }
        })
    }
    
    func saveUser(user: User){
        //set User information into firebase
        getUserRef().childByAppendingPath(user.uid).setValue(user.providerData)
    }
    
    func getUsers(completion:StringErrorCompletionBlock) {
        let ref = getUserRef()
        // Get the data on a post that has changed
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            //TODO: write actual NSError for empty snapshot
            if (snapshot == nil) {
                completion(nil, nil)
                return
            }
            
            let users = snapshot.value as! [String:NSObject] //get all Users
            
            var usernames = [String]()
            
            for key in users.keys {// Parse based upon Keys
                if let profileInfo = users[key] as? [String:NSObject] {
                    let profileName = profileInfo["displayName"] as! String
                    usernames.append(profileName)
                }
            }
            
            completion(usernames, nil)
            
        })
    }
    
    func checkIfUserExist(userToCheck:User) -> Bool {
        //return getUserRef().childSnapshotForPath("/\(userToCheck.uid)").exists()
        return true
    }
    
    //MARK: - KickSwap Methods
    func saveShoes(shoeToSave: Shoe){
        let shoeRef = getRefWith("shoes").childByAutoId()
        shoeRef.setValue(shoeToSave.getShoe())
        
        //TODO: append key to user locker
        //var shoeId = shoeRef.key
    }
    
    func logOut() {
        return getRef().unauth()
    }
    
}
