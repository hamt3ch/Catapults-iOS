 //
//  Firebase.swift
//  KickSwap
//
//  Created by Hugh A. Miles II on 2/17/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import Firebase

//TODO: Create Completion blocks
protocol FirebaseLoginDelegate: class {
    func loginCompletion() -> Void
    func loginFailure(error: NSError?) -> Void
}

typealias StringErrorCompletionBlock = ([String]?, NSError?) -> Void
typealias UserErrorCompletionBlock = (User?, NSError?) -> Void
typealias UserArrayErrorCompletionBlock = ([User]?, NSError?) -> Void

class FirebaseClient: NSObject {
    
    static let sharedClient = FirebaseClient()
    static let baseURL = "https://kickswap.firebaseio.com"
    
    weak var loginDelegate: FirebaseLoginDelegate?
    
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
    
    func loginWithFacebook(fbAccessToken:String, completion:UserErrorCompletionBlock) {
        //Authenticate with facebookID
        FirebaseClient.sharedClient.getRef().authWithOAuthProvider("facebook", token: fbAccessToken,
            withCompletionBlock: { error, authData in
                if error != nil {
                    print("Login failed. \(error)")
                    self.loginDelegate?.loginFailure(error)
                    completion(nil, error)
                    return
                } else {
                    //set global currentUser
                    let newUser = User(data: authData)
                    User.currentUser = newUser
                    print("User logging in thru FB: \(User.currentUser)")
                    //set value back into Firebase
                    // FirebaseClient.saveUser(User.currentUser!)
                    completion(newUser, nil)
                    //self.loginDelegate?.loginCompletion()
                }
        })
    }
    
    func saveUser(user: User){
        //set User information into firebase
        getUserRef().childByAppendingPath(user.uid).setValue(user.providerData)
    }
    
    func getUsers(completion:UserArrayErrorCompletionBlock) {
        let ref = getUserRef()
        // Get the data on a post that has changed
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            //TODO: write actual NSError for empty snapshot
            if (snapshot == nil) {
                completion(nil, nil)
                return
            } else {
                let users = snapshot.value as! [String:NSObject] //get all Users
                var userArray = [User]()
                for key in users.keys {
                    if let profileInfo = users[key] as? [String:NSObject] {
                        print(profileInfo)
                        userArray.append(User(dictionary: profileInfo as NSDictionary, id: key))
                    }
                }
                
                completion(userArray,nil)
            }
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
