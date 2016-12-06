//
//  NewUserViewController.swift
//  Cirquet-app
//
//  Created by Kurt Bitner on 12/5/16.
//  Copyright © 2016 Kurt Bitner. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON

class NewUserViewController: UIViewController, UITextFieldDelegate {

   
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var ageField: UITextField!
    
    var isHost = false
    var idToken: String = ""
    var givenName: String = ""
    var familyName: String = ""
    var email: String = ""
    let date: Double = floor(Date().timeIntervalSince1970)
    var userid: String = ""
    var age: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = GIDSignIn.sharedInstance().currentUser
        self.idToken = (user?.authentication.idToken)!
        self.givenName = (user?.profile.givenName)!
        self.familyName = (user?.profile.familyName)!
        self.email = (user?.profile.email)!
        self.ageField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUpAsUser(_ sender: UIButton) {
        self.hostButton.isEnabled = false
        
        guard !(self.ageField.text?.isEmpty)! else {
            let al = UIAlertController(title: "Missing Input", message: "Please enter an age to continue.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        guard Int(ageField.text!)! < 13  else {
            let al = UIAlertController(title: "Invalid input", message: "You must be 13 or older to use this app.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        self.age = Int(ageField.text!)!
        let reg = Just.post("https://www.cirquet.com/register", data: ["fname": givenName, "lname": familyName, "email": email, "age": age, "host": isHost, "googleid": idToken, "date": date ])
        if reg.ok {
            var js = JSON(data: reg.content!)
            if js["exists"].bool!  {
                self.userid = js["sender_id"].string!
                self.performSegue(withIdentifier: "QRCode", sender: self)
            }
            
        }
        
    }
    @IBAction func signUpAsHost(_ sender: UIButton) {

        self.isHost = true
        guard !(self.ageField.text?.isEmpty)! else {
            let al = UIAlertController(title: "Missing Input", message: "Please enter an age to continue.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        guard Int(ageField.text!)! < 13  else {
            let al = UIAlertController(title: "Invalid input", message: "You must be 13 or older to use this app.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        self.userButton.isEnabled = false
        self.age = Int(ageField.text!)!
        let reg = Just.post("https://www.cirquet.com/register", data: ["fname": givenName, "lname": familyName, "email": email, "age": age, "host": isHost, "googleid": idToken, "date": date ])
        if reg.ok {
            var js = JSON(data: reg.content!)
            if js["exists"].bool!  {
                self.userid = js["sender_id"].string!
                self.performSegue(withIdentifier: "SetUpVenue", sender: self)
            }
            
        }
        
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("begin segue")
        if segue.identifier == "QRCode" {
            if let dest = segue.destination as? QRCodeViewController {
                dest.userid = self.userid
            }
        }
        else if segue.identifier == "SetUpVenue" {
            if let dest = segue.destination as? VenueViewController {
                dest.userid = self.userid
            }
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
