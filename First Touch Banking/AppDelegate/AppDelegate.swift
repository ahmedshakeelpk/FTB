//
//  AppDelegate.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Siren
import Fabric
import Crashlytics
import SwiftKeychainWrapper

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       
        if !UserDefaults.standard.bool(forKey: "firstTimeLaunchOccurred"){
            KeychainWrapper.standard.removeAllKeys()
            print("\(KeychainWrapper.standard.removeAllKeys())")
            UserDefaults.standard.set(true, forKey: "firstTimeLaunchOccurred")
        }
        
        // Siren Pod for Version Check
        self.setupSiren()
        // Crashlytics Pod
        Fabric.with([Crashlytics.self])
        return true
    }
    
    func setupSiren() {
        let sirenObj = Siren.shared
        
        // If app is available only in Pakistan AppStore
        sirenObj.countryCode = "PK"
       
        // Optional
        sirenObj.delegate = self as? SirenDelegate
        
        // Optional
        sirenObj.debugEnabled = true
        
        sirenObj.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
        sirenObj.alertType = .force
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        self.window?.isHidden = true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
     //   self.window?.isHidden = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Siren.shared.checkVersion(checkType: .immediately)
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Siren.shared.checkVersion(checkType: .immediately)
        self.ExitOnJailbreak()
        self.window?.isHidden = false
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
   
    // MARK: - Jail Break Check
    
    
    func isJailbroken() -> Bool {
        
        if TARGET_IPHONE_SIMULATOR != 1 {
            // Check 1 : existence of files that are common for jailbroken devices
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
                || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
                || FileManager.default.fileExists(atPath: "/bin/bash")
                || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
                || FileManager.default.fileExists(atPath: "/etc/apt")
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
                || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!)
                || UIApplication.shared.canOpenURL(URL(string:"/Applications/Cydia.app")!)
                || UIApplication.shared.canOpenURL(URL(string:"/Library/MobileSubstrate/MobileSubstrate.dylib")!)
                || UIApplication.shared.canOpenURL(URL(string:"/bin/bash")!)
                || UIApplication.shared.canOpenURL(URL(string:"/usr/sbin/sshd")!)
                || UIApplication.shared.canOpenURL(URL(string:"/etc/apt")!)
                || UIApplication.shared.canOpenURL(URL(string:"/usr/bin/ssh")!)
                || UIApplication.shared.canOpenURL(URL(string:"cydia:package/com.example.package")!){
                
                print("JailBreak Device")
                return true
            }
            
            // Check 2 : Reading and writing in system directories (sandbox violation)
            
            let stringToWrite = "Jailbreak Test"
            do{
                try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
                print("JailBreak Device")
                return true
            }
            catch{
                return false
            }
        }
        else{
            print("Running on Simmulator")
            return false
        }
    }
    
    // MARK: -  Call this Jail Break Check
    
    func ExitOnJailbreak() {
        
        if isJailbroken() == true {
            // Exit the app if Jailbroken
            let alert = UIAlertController(title: "JailBreak Device", message:"This app is not supported on JailBreak Devices", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil) }))
            // show the alert
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
        }
    }


}

