//
//  AppDelegate.swift
//  Orthodox Radio
//
//  Created by Sukumar Anup Sukumaran on 01/03/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    var mainDATA = MainViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        UIApplication.shared.statusBarStyle = .lightContent
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
       // mainDATA.deallocatedObservers()
        
       print("WillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
     print("applicationDidBecomeActive")
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
        UIApplication.shared.endReceivingRemoteControlEvents()
        
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)

        guard let event = event, event.type == UIEventType.remoteControl else {
            
            return
        }

        switch event.subtype {
        case .remoteControlPlay:
            print("Playing")
            NotificationCenter.default.post(name: NSNotification.Name("playNEW"), object: nil)
        case .remoteControlPause:
            print("Pause")
             NotificationCenter.default.post(name: NSNotification.Name("pauseNEW"), object: nil)
        case .remoteControlTogglePlayPause:
            print("TogglePlayPause")
        case .remoteControlNextTrack:
            print("NextTrack")
        case .remoteControlPreviousTrack:
            print("Previous")
        default:
            break
        }

    }


}

