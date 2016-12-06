//
//  GenerateQRViewController.swift
//  Cirquet-app
//
//  Created by Kurt Bitner on 12/6/16.
//  Copyright © 2016 Kurt Bitner. All rights reserved.
//

import UIKit
import Just
import AssetsLibrary

class GenerateQRViewController: UIViewController {
    var chatname: String = ""
    var chatid: String = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qrCode: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = chatname
        var r = Just.get("https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=\(chatid)")
        if r.ok {
            qrCode.image = UIImage(data: r.content!)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func savePhoto(_ sender: UIButton) {
        var img = self.qrCode.image!
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let al = UIAlertController(title: "Error", message: "Unable to save qr code to library. \(error.localizedDescription)", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
        }
        else {
            let al = UIAlertController(title: "Success", message: "The QR code has been saved to the photo library", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(al, animated: true, completion: nil)
            
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
