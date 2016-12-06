//
//  AppDelegate.swift
//  Cirquet-app
//
//  Created by Kurt Bitner on 11/13/16.
//  Copyright © 2016 Kurt Bitner. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var configureError: NSError?;
        GGLContext.sharedInstance().configureWithError(&configureError);
        assert(configureError == nil, "Error confituring Google Services \(configureError)");
        GIDSignIn.sharedInstance().delegate = self;
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            var vc = self.window?.rootViewController as! ViewController
            let userID = user.userID
            let idToken = user.authentication.idToken
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let date: Double = floor(Date().timeIntervalSince1970)
            let login = Just.post("https://www.cirquet.com/login", data: ["googleid": idToken!])
            
            
            if(login.ok) {
                var js = JSON(data: login.content!)
                print(js)
                var id: String = js["sender_id"].stringValue
                if js["exists"].boolValue {
                    if !js["is_host"].boolValue {
                        //vc.myText.text = r.text!
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        var vc2 = storyboard.instantiateViewController(withIdentifier: "codeviewcontroller")
                        window?.rootViewController?.present(vc2, animated: true, completion: nil)
                    }
                    else {
                        print("else")
                        var res2 = Just.post("https://www.cirquet.com/get-chat-id", data: ["id": id])
                        print(res2.statusCode)
                        var js3 = JSON(data: res2.content!)
                        if js3["success"].boolValue {
                            let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
                            let vc123 = storyboard1.instantiateViewController(withIdentifier: "generateqrcontroller")
                            (vc123 as? GenerateQRViewController)?.chatid = js3["chatid"].stringValue
                            (vc123 as? GenerateQRViewController)?.chatname = js3["chatname"].stringValue
                            window?.rootViewController?.present(vc123, animated: true, completion: nil)
                        }
                    }
                    
                    
                }
                else {
                    let storyboard2 = UIStoryboard(name: "Main", bundle: nil)
                    var vc3 = storyboard2.instantiateViewController(withIdentifier: "newuserviewcontroller")
                    window?.rootViewController?.present(vc3, animated: true, completion: nil)
                }
            }
            
            
            
        }
        else {
            print("\(error.localizedDescription)")
        }
        
    }
    func sign( signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
