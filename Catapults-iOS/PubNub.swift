//
//  PubNub.swift
//  Catapults-iOS
//
//  Created by Hugh A. Miles II on 3/9/16.
//  Copyright © 2016 Hugh A. Miles II. All rights reserved.
//

import PubNub

let publishKey = "pub-c-baa81eb3-c043-4cd8-8b5a-3dc257ded619"
let subcribeKey = "sub-c-7539a622-e5f2-11e5-aad5-02ee2ddab7fe"

protocol PubNubChatDelegate: class {
    func messagesRecievedCompletion(messagesRecieved:[String]?) -> Void
}

class PubNubClient: NSObject, PNObjectEventListener {
    
    // Instance property
    static let sharedClient = PubNubClient()
    var client: PubNub?
    
    weak var chatDelegate: PubNubChatDelegate?
    
    
    //Variables
    var recievedMessages: AnyObject?
    
    // For demo purposes the initialization is done in the init function so that
    // the PubNub client is instantiated before it is used.
    override init() {
        
        // Instantiate configuration instance.
        let configuration = PNConfiguration(publishKey: publishKey, subscribeKey: subcribeKey)
        // Instantiate PubNub client.
        client = PubNub.clientWithConfiguration(configuration)
        
        super.init()
        client?.addListener(self)
    }
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.actualChannel != nil {
            
            // Message has been received on channel group stored in
            // message.data.subscribedChannel
        }
        else {
            
            // Message has been received on channel stored in
            // message.data.subscribedChannel
        }
        
        print("Received message: \(message.data.message) on channel " +
            "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
            "\(message.data.timetoken)")
    }
    
    // New presence event handling.
    func client(client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout,
        // state-change).
        if event.data.actualChannel != nil {
            
            // Presence event has been received on channel group stored in
            // event.data.subscribedChannel
        }
        else {
            
            // Presence event has been received on channel stored in
            // event.data.subscribedChannel
        }
        
        if event.data.presenceEvent != "state-change" {
            
            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) " +
                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
        else {
            
            print("\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) " +
                "on \((event.data.actualChannel ?? event.data.subscribedChannel)!) to:\n" +
                "\(event.data.presence.state)");
        }
    }
    
    // Handle subscription status change.
    func client(client: PubNub, didReceiveStatus status: PNStatus) {
        if status.category == .PNUnexpectedDisconnectCategory {
            
            // This event happens when radio / connectivity is lost
        }
        else if status.category == .PNConnectedCategory {
            
            // Connect event. You can do stuff like publish, and know you'll get it.
            // Or just use the connected event to confirm you are subscribed for
            // UI / internal notifications, etc
            
            // Select last object from list of channels and send message to it.
            let targetChannel = client.channels().last
            client.publish("Hello from the PubNub Swift SDK", toChannel: targetChannel!,
                compressed: false, withCompletion: { (status) -> Void in
                    
                    if !status.error {
                        
                        // Message successfully published to specified channel.
                    }
                    else{
                        // Handle message publish error. Check 'category' property
                        // to find out possible reason because of which request did fail.
                        // Review 'errorData' property (which has PNErrorData data type) of status
                        // object to get additional information about issue.
                        //
                        // Request can be resent using: status.retry()
                    }
            })
        }
        else if status.category == .PNReconnectedCategory {
            
            // Happens as part of our regular operation. This event happens when
            // radio / connectivity is lost, then regained.
        }
        else if status.category == .PNDecryptionErrorCategory {
            
            // Handle messsage decryption error. Probably client configured to
            // encrypt messages and on live data feed it received plain text.
        }
    }
    
    //MARK: - Public Methods Controller Uses
    func sendMessage(messageToSend: String) {
        self.client!.publish(messageToSend, toChannel: "my_channel",
            compressed: false, withCompletion: { (status) -> Void in
                
                if !status.error {
                    
                    // Message successfully published to specified channel.
                }
                else {
                    // Handle message publish error. Check 'category' property
                    // to find out possible reason because of which request did fail.
                    // Review 'errorData' property (which has PNErrorData data type) of status
                    // object to get additional information about issue.
                    //
                    // Request can be resent using: status.retry()
                }
        })
    }
    
    func getMessages(channel:String) -> [String] {
        var recievedMessages:[String] = [String]()
        self.client?.historyForChannel(channel, withCompletion: { (result, status) -> Void in
            
            if status == nil {
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
                print(result!.data.messages)
                recievedMessages = result!.data.messages as! [String]
                self.chatDelegate?.messagesRecievedCompletion(recievedMessages)
            
            }
                
            else {
                
                // Handle message history download error. Check 'category' property
                // to find out possible reason because of which request did fail.
                // Review 'errorData' property (which has PNErrorData data type) of status
                // object to get additional information about issue.
                //
                // Request can be resent using: status.retry()
            }
        })
        print(recievedMessages)
        return recievedMessages
   }
    

}
