//
//  VenueViewController.swift
//  Cirquet-app
//
//  Created by Kurt Bitner on 12/5/16.
//  Copyright © 2016 Kurt Bitner. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON

class VenueViewController: UIViewController {
    var userid: String = ""
    var chatid: String = ""
    var chatname: String = ""
    
    @IBOutlet weak var venueName: UITextField!
    @IBOutlet weak var chatName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitToServer(_ sender: UIButton) {
        print(self.userid)
        guard !(venueName.text?.isEmpty)! else {
            let al = UIAlertController(title: "Missing Input", message: "Please enter a venue name to continue.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        var venueNameText: String = venueName.text!
        guard !(chatName.text?.isEmpty)! else {
            let al = UIAlertController(title: "Missing Input", message: "Please enter a chat name to continue.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        var chatNameText: String = chatName.text!
        guard !(address.text?.isEmpty)! else {
            let al = UIAlertController(title: "Missing Input", message: "Please enter an address to continue.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        var addressText: String = address.text!
        guard !(city.text?.isEmpty)! else {
            let al = UIAlertController(title: "Missing Input", message: "Please enter a city to continue.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        var cityText: String = city.text!
        guard !(state.text?.isEmpty)! else {
            let al = UIAlertController(title: "Missing Input", message: "Please enter a state to continue.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        var stateText: String = state.text!
        guard !(zip.text?.isEmpty)! else {
            let al = UIAlertController(title: "Missing Input", message: "Please enter a zip to continue.", preferredStyle: UIAlertControllerStyle.alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            return
        }
        var zipText: Int = Int(zip.text!)!
        var r = Just.post("https://www.cirquet.com/create-venue", data: ["id": self.userid, "addr": addressText, "city": cityText, "state": stateText, "zip": zipText, "chatname": chatNameText, "venuename": venueNameText])
        if r.ok {
            var js = JSON(data: r.content!)
            if js["success"].boolValue {
                self.chatname = js["chatname"].stringValue
                self.chatid = js["chatid"].stringValue
                self.performSegue(withIdentifier: "generateQR", sender: self)
                
            }
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "generateQR" {
            if let dest = segue.destination as? GenerateQRViewController {
                dest.chatid = self.chatid
                dest.chatname = self.chatname
            }
        }
    }
    
    

}
