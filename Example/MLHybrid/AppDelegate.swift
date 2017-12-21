//
//  AppDelegate.swift
//  MLHybrid
//
//  Created by yang cai on 08/08/2017.
//  Copyright (c) 2017 yang cai. All rights reserved.
//

import UIKit
import MLHybrid
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        sess    cr2iPYCeaU6ElkldDKowOoJFpSqVaWXRZIFbk7vNbA9xQ3IvK8h2QtYwujGj1esT    .medlinker.com    /    2018/3/23 下午7:06:57    68 B

        MLHybrid.register(sess: "cr2iPYCeaU6ElkldDKowOoJFpSqVaWXRZIFbk7vNbA9xQ3IvK8h2QtYwujGj1esT",
                          platform: "i",
                          appName: "medlinker",
                          domain: "medlinker.com",
                          backIndicator: "hybridBack",
                          delegate: MethodExtension())
        
        MLHybrid.checkVersion()
    
     
        return true
    }

    
//    override func remoteControlReceived(with event: UIEvent?) {
//        if let event = event{
//            player.remoteControlReceived(with: event)
//            
//        }
//    }
    
//    func remoteControlReceivedWithEvent(event: UIEvent?) {
//        if let event = event {
//            player.remoteControlReceivedWithEvent(event)
//        }
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
       
        application.beginReceivingRemoteControlEvents()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        application.beginBackgroundTask(expirationHandler: nil)
//        let session = AVAudioSession.sharedInstance()
//        try? session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
//        try? session.setActive(true)
//        application.beginReceivingRemoteControlEvents()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

