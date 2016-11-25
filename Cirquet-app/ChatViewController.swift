//
//  ChatViewController.swift
//  Cirquet-app
//
//  Created by Kurt Bitner on 11/17/16.
//  Copyright © 2016 Kurt Bitner. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Just

class ChatViewController: JSQMessagesViewController {
    var msg = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        var r = Just.post("https://www.cirquet.com/get-id", data: ["gid": GIDSignIn.sharedInstance().currentUser.authentication.idToken])
        if r.ok {
            self.senderId = r.text
            print(self.senderId)
        }
        self.senderDisplayName = GIDSignIn.sharedInstance().currentUser.profile.givenName
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        
      
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return msg[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msg.count
    }
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bimgfactory = JSQMessagesBubbleImageFactory()
        return bimgfactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
    }
    private func setupIncomingBubble () -> JSQMessagesBubbleImage {
        let bimgfactory = JSQMessagesBubbleImageFactory()
        return bimgfactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let mesg = msg[indexPath.item]
        if mesg.senderId == self.senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            msg.append(message)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let mesg = msg[indexPath.item]
        if mesg.senderId == self.senderId {
            c.textView?.textColor = UIColor.white
        } else {
            c.textView?.textColor = UIColor.black
        }
        return c
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let r = Just.post("https://www.cirquet.com/message", data: ["msg": text, "date": String(floor(date.timeIntervalSince1970)), "id": senderId, "chat": "abc1234snf"])
        if r.ok {
            var mesg = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text)
            print(r.statusCode)
            msg.append(mesg!)
            finishSendingMessage()
        }
        else {
            print(r.statusCode)
        }
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

