//
//  ChatController.swift
//  FireChat
//
//  Created by hackeru on 16 Kislev 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseAuth

class ChatController: JSQMessagesViewController {
    
    var data: [JSQMessage] = []
    var topic: Topic!
    //computed properties:
    
    var user: User?{
        return Auth.auth().currentUser
    }
    
    var messageRef: DatabaseReference{
        
        //TopicMessages
        //  --> 00dsf2300fsdf0sd0f
        //          hi, time, senderID, sender Name
        //          whats app?, time, senderID, sender Name
        return Database.database().reference(withPath: "TopicMessages").child(topic.id)
    }
    
    //setup the bubble colors:
    lazy var incoming: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var outgoing: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageRef.observe(.childAdded) { (snapshot) in
            guard let message: JSQMessage = JSQMessage(snapshot: snapshot) else {return}
            
            self.data.append(message)
            ////self.collectionView.insertItems(at: )
            self.finishReceivingMessage()
        }
        
        //TODO: Fix!!!
        //        //tell JSQ Who am I...
        guard let user = self.user else {
            return
        }
        self.senderId = user.uid
        self.senderDisplayName = user.displayName ?? "annonynous"
        
        //setup the bubbles: incoming and outgoing bubbles
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    //set the bubble colors for incoming / outgoing
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = data[indexPath.item]
        
        return message.senderId == senderId ? outgoing : incoming
    }
    
    //MARK: Data source
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return data[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)!
        
        //     let r =  Database.database().reference(withPath: "TopicMessages").child(topic.id)
        //save the message to the cloud:
        messageRef.childByAutoId().setValue(message.json)
        
        //notify the collection view
        finishSendingMessage()
        //play sound
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let msg = data[indexPath.item]
        
        return NSAttributedString(string: msg.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 20
    }
}

extension JSQMessage{
    //Serialization to Json
    var json:Json{
        return [
            "senderId" : senderId,
            "senderDisplayName": senderDisplayName,
            "text" : text,
            "date" : date.timeIntervalSince1970 * 1000
        ]
    }
    
    //Deserialization from json
    convenience init?(snapshot: DataSnapshot) {
        guard let json = snapshot.value as? Json,
            let senderId = json["senderId"] as? String,
            let senderDisplayName  = json["senderDisplayName"] as? String,
            let date = json["date"] as? TimeInterval,
            let text = json["text"] as? String
            else{return nil}
        
        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: Date(timeIntervalSince1970: date), text: text)
    }
}


