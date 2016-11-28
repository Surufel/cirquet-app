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
import SwiftyJSON


class ChatViewController: JSQMessagesViewController {
    var msg = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var chatid: String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.chatid + " hi")
        var r = Just.post("https://www.cirquet.com/get-id", data: ["gid": GIDSignIn.sharedInstance().currentUser.authentication.idToken])
        if r.ok {
            self.senderId = r.text
            print(self.senderId)
        }
        
        self.senderDisplayName = GIDSignIn.sharedInstance().currentUser.profile.givenName
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        //observeMessages()
        let cqueue = DispatchQueue(label: "msgquery", attributes: .concurrent)
        cqueue.sync {
            if msg.count == 0 {
                let r = Just.post("https://www.cirquet.com/last5", data: ["cid":self.chatid])
                if r.ok {
                    //let js =
                    print(r.text)
                    let js = JSON(data: r.content!)
                    if js.count == 0 {
                        
                    }
                    else {
                        for i in 0..<js.count {
                            addMessage(withId: js[i]["owner"].stringValue, name: "test", text: js[i]["contents"].stringValue)
                        }
                        finishReceivingMessage()
                    }
                }
            }
        }
        cqueue.async {
            while true && self.msg.count > 0{
                
                let r = Just.post("https://www.cirquet.com/get-message", data: ["time": floor((self.msg.last?.date.timeIntervalSince1970)!), "id": self.senderId, "cid":self.chatid])
                if r.ok {
                    let js = JSON(data: r.content!)
                    if js.count == 0 {}
                    else {
                        for i in 0..<js.count {
                            if js[i]["owner"].stringValue == self.senderId {
                                print("discarding message")
                                continue
                            }
                            self.addMessage(withId: js[i]["owner"].stringValue, name: "test", text: js[i]["contents"].stringValue)
                            self.finishReceivingMessage()
                        }
                    }
                }
            }
        }
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
        let r = Just.post("https://www.cirquet.com/message", data: ["msg": text, "date": String(floor(date.timeIntervalSince1970)), "id": senderId, "chat": self.chatid])
        if JSON(data: r.content!)["success"].bool! {
              addMessage(withId: self.senderId, name: self.senderDisplayName, text: text)
            finishSendingMessage()
        }
        else {
            print(r.statusCode)
        }
    }
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("not implemented yet")
        let al = UIAlertController(title: "Sorry...", message: "Sending images will be available at a later time.", preferredStyle: .alert)
        al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(al, animated: true, completion: nil)
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


