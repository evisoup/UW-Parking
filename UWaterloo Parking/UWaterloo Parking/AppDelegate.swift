//
//  AppDelegate.swift
//  UWaterloo Parking
//
//  Created by 刘恒邑 on 16/2/17.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func grabStoryBoard() -> UIStoryboard {
        var storyboard = UIStoryboard()
        let height = UIScreen.mainScreen().bounds.size.height
        
        if height == 667.0 {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        } else if height == 736.0 {
            storyboard = UIStoryboard(name: "MainForPlus", bundle: nil)
        } else if height == 568.0 {
            storyboard = UIStoryboard(name: "MainFor55S", bundle: nil)
        } else {
            storyboard = UIStoryboard(name: "MainFor4S", bundle: nil)
        }
        return storyboard
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let storyboard: UIStoryboard = self.grabStoryBoard()
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        self.window!.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        let colour = UIColor(red: 252/255.0, green: 212/255.0, blue: 80/255.0, alpha: 1.0)
        UITabBar.appearance().tintColor = colour
        
        UINavigationBar.appearance().barTintColor = colour
        // UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor()]
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}