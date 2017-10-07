//
//  AppDelegate.swift
//  Remind me
//
//  Created by Jari Koopman on 27/09/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        
        window.backgroundColor = .white
        
        let remindersController = RemindersViewController()
        let navigationController = UINavigationController(rootViewController: remindersController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if let error = error {
                let e = error as NSError
                print("Unresolved error: \(e), \(e.userInfo)")
            }
        }
        center.removeAllDeliveredNotifications()
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        CDController.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CDController.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CDController.save()
    }
}
