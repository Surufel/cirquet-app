//
//  ViewController.swift
//  Cirquet-app
//
//  Created by Kurt Bitner on 11/13/16.
//  Copyright © 2016 Kurt Bitner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate {
    //@IBOutlet weak var myText: UITextView!
    var chatViewController: ChatViewController!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
        }
        //GIDSignIn.sharedInstance().signInSilently()
        
        //self.myText.text = "Label"
        
       
    }
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
        
       
    }
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToBeginning(segue: UIStoryboardSegue) {
        
    }
    
    

}




