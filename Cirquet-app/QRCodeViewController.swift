//
//  QRCodeViewController.swift
//  Cirquet-app
//
//  Created by Kurt Bitner on 11/28/16.
//  Copyright © 2016 Kurt Bitner. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import Just

class QRCodeViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
    })
    var chatid: String = ""
    var chatname: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func scanNow(_ sender: UIButton) {
        reader.delegate = self
        reader.completionBlock = {
            (result: QRCodeReaderResult?) in
            //print((result?.value)!)
            self.chatid = (result?.value)!
            let r = Just.post("https://www.cirquet.com/get-chat", data: ["cid": self.chatid])
            if r.ok {
                self.chatname = r.text!
            }
            else {
                print(r.statusCode)
            }
            
        }
        reader.modalPresentationStyle = .formSheet
        present(reader, animated: true, completion: nil)
    }
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        self.reader.stopScanning()
        dismiss(animated: true, completion: {
            () -> Void in
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //var vc2 = storyboard.instantiateViewController(withIdentifier: "chatviewcontroller")
            //self.present(vc2, animated: true, completion: nil)
            self.performSegue(withIdentifier: "SendToChat", sender: self)
        })
        
        
        
    }
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        //
    }
    func readerDidCancel(_ reader: QRCodeReaderViewController) -> Void {
        self.reader.stopScanning()
        dismiss(animated: true, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("begin segue")
        if segue.identifier == "SendToChat" {
            if let dest = segue.destination as? ChatContainerViewController {
                dest.chatid = self.chatid
                dest.chatTitle = self.chatname
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
