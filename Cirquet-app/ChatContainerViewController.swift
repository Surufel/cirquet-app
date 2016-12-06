//
//  ChatContainerViewController.swift
//  Cirquet-app
//
//  Created by Kurt Bitner on 11/28/16.
//  Copyright © 2016 Kurt Bitner. All rights reserved.
//

import UIKit
import Just

class ChatContainerViewController: UIViewController {
    
    var chatTitle: String = ""
    var chatid: String = ""
    var userid: String = ""
    //var seg: String = ""
    @IBOutlet weak var bar: UINavigationBar!
    @IBOutlet weak var chatView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.chatid = self.seg
        self.bar.topItem?.title = self.chatTitle
        
        (self.childViewControllers.last as? ChatViewController)?.chatid = self.chatid
        (self.childViewControllers.last as? ChatViewController)?.senderId = self.userid
        print(((self.childViewControllers.last as? ChatViewController)?.chatid)!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPressLogout(_ sender: Any) {
        GIDSignIn.sharedInstance().disconnect()
        self.performSegue(withIdentifier: "beginning2", sender: self)
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
