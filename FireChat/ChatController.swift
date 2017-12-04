//
//  ChatController.swift
//  FireChat
//
//  Created by hackeru on 16 Kislev 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatController: JSQMessagesViewController {

    var data: [JSQMessage] = []
    var topic: Topic!
    
    //setup the bubble colors:
    lazy var incoming: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var outgoing: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.append(JSQMessage(senderId: "2", displayName: "Steve", text: "Are you up? Need your help."))
        data.append(JSQMessage(senderId: "1", displayName: "Tomer", text: "Sorry, Busy. call my secratary..."))
        data.append(JSQMessage(senderId: "3", displayName: "Tim", text: "Oh, I See. Bummer!"))
        data.append(JSQMessage(senderId: "1", displayName: "Tomer", text: "Yeah, See ya..."))
        data.append(JSQMessage(senderId: "1", displayName: "Tomer", text: "Bye."))
        
        //tell JSQ Who am I...
        self.senderId = "1"
        self.senderDisplayName = "Tomer"
        
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
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        
        //add the message to the array
        data.append(message!)
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

}
