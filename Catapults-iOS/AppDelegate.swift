//
//  AppDelegate.swift
//  Catapults-iOS
//
//  Created by Hugh A. Miles II on 3/9/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import UIKit
import CoreData
import PubNub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?
    var chatClient = PubNubClient() // instantiate pubNub Client for chat

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        PubNubClient.sharedClient.client?.subscribeToChannels(["my_channel"], withPresence: true)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "ham.Catapults_iOS" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Catapults_iOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: PUBNUB - Object Event Listener
//    
//    // Instance property
//    var client: PubNub?
//    
//    // For demo purposes the initialization is done in the init function so that
//    // the PubNub client is instantiated before it is used.
//    override init() {
//        
//        // Instantiate configuration instance.
//        let configuration = PNConfiguration(publishKey: "pub-c-83582cfe-d7a4-4f1d-b727-aa0479dda211", subscribeKey: "sub-c-0dacfca8-e5e7-11e5-aad5-02ee2ddab7fe")
//        // Instantiate PubNub client.
//        client = PubNub.clientWithConfiguration(configuration)
//        
//        super.init()
//        client?.addListener(self)
//    }
//
//    // Handle new message from one of channels on which client has been subscribed.
//    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
//        
//        // Handle new message stored in message.data.message
//        if message.data.actualChannel != nil {
//            
//            // Message has been received on channel group stored in
//            // message.data.subscribedChannel
//        }
//        else {
//            
//            // Message has been received on channel stored in
//            // message.data.subscribedChannel
//        }
//        
//        print("Received message: \(message.data.message) on channel " +
//            "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
//            "\(message.data.timetoken)")
//    }
//    
//    // New presence event handling.
//    func client(client: PubNub!, didReceivePresenceEvent event: PNPresenceEventResult!) {
//        
//        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout,
//        // state-change).
//        if event.data.actualChannel != nil {
//            
//            // Presence event has been received on channel group stored in
//            // event.data.subscribedChannel
//        }
//        else {
//            
//            // Presence event has been received on channel stored in
//            // event.data.subscribedChannel
//        }
//        
//        if event.data.presenceEvent != "state-change" {
//            
//            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
//                "at: \(event.data.presence.timetoken) " +
//                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) " +
//                "(Occupancy: \(event.data.presence.occupancy))");
//        }
//        else {
//            
//            print("\(event.data.presence.uuid) changed state at: " +
//                "\(event.data.presence.timetoken) " +
//                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) to:\n" +
//                "\(event.data.presence.state)");
//        }
//    }
//    
//    // Handle subscription status change.
//    func client(client: PubNub, didReceiveStatus status: PNStatus) {
//        if status.category == .PNUnexpectedDisconnectCategory {
//            
//            // This event happens when radio / connectivity is lost
//        }
//        else if status.category == .PNConnectedCategory {
//            
//            // Connect event. You can do stuff like publish, and know you'll get it.
//            // Or just use the connected event to confirm you are subscribed for
//            // UI / internal notifications, etc
//            
//            // Select last object from list of channels and send message to it.
//            let targetChannel = client.channels().last
//            client.publish("Hello from the PubNub Swift SDK", toChannel: targetChannel!,
//                compressed: false, withCompletion: { (status) -> Void in
//                    
//                    if !status.error {
//                        
//                        // Message successfully published to specified channel.
//                    }
//                    else{
//                        // Handle message publish error. Check 'category' property
//                        // to find out possible reason because of which request did fail.
//                        // Review 'errorData' property (which has PNErrorData data type) of status
//                        // object to get additional information about issue.
//                        //
//                        // Request can be resent using: status.retry()
//                    }
//            })
//        }
//        else if status.category == .PNReconnectedCategory {
//            
//            // Happens as part of our regular operation. This event happens when
//            // radio / connectivity is lost, then regained.
//        }
//        else if status.category == .PNDecryptionErrorCategory {
//            
//            // Handle messsage decryption error. Probably client configured to
//            // encrypt messages and on live data feed it received plain text.
//        }
//    }
//
}

