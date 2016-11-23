//
//  ChatViewController.swift
//  Cirquet-app
//
//  Created by Kurt Bitner on 11/17/16.
//  Copyright © 2016 Kurt Bitner. All rights reserved.
//

import UIKit
import Starscream
import Just

class ChatViewController: UIViewController {

    @IBOutlet weak var textArea: UITextField!
    @IBOutlet weak var connectedLabel: UILabel!

    @IBOutlet weak var textView: UITextView!


   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connected(_ sender: UIButton) {
        if textArea.text != "" {
            var str = textArea.text
            //print(GIDSignIn.sharedInstance().currentUser.authentication.idToken)
            var r = Just.post("http://0.0.0.0:8080/message", data:
                   ["gid": GIDSignIn.sharedInstance().currentUser.authentication.idToken,
                    "msg": str!,
                    "date": floor(Date().timeIntervalSince1970),
                    "chat": "abcdefg123456snf"
                    ])
            print(r.statusCode)
            if r.ok {
                textView.text = r.text
            }
            
        }
        else {
            print("no text")
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
