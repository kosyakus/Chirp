//
//  AppDelegate.swift
//  ChirpApp
//
//  Created by Natali on 15/12/2018.
//  Copyright © 2018 Natali. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //let connect: ChirpConnect = ChirpConnect(appKey: "5b894CeE9Cdc5B0ef67CfC9c4", andSecret: "eb34d1aA8beD59ecb83520BF2116F2CbFF22f5F2e0fCfeEB4b")!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        /*connect.setConfigFromNetworkWithCompletion {
            (error: Error?) in
            if error == nil {
                self.connect.start()
            }
        }
        
        let data: Data = connect.randomPayload(withLength: UInt(connect.maxPayloadLength))
        connect.send(data)
        
        connect.receivedBlock = {
            (data : Data?, channel: UInt?) -> () in
            if let data = data {
                print(String(data: data, encoding: .ascii) as Any)
                return;
            }
        }*/
        
        return true
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

