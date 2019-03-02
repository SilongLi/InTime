//
//  AppDelegate.swift
//  InTime
//
//  Created by BruceLi on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupAppearance()
        
        setupWindow()
        
        HomeSeasonViewModel.initDefaultCategorys()
        
        setupLocalNotification()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let NAV = UINavigationController(rootViewController: HomeViewController())
        self.window?.rootViewController = NAV
        self.window?.backgroundColor = .white
        self.window?.makeKey()
        self.window?.makeKeyAndVisible()
    }
    
    func setupAppearance() { 
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().tintAdjustmentMode = .automatic
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    /// 注册本地通知
    func setupLocalNotification() {
        /// iOS 10.0之后使用UNNotificationRequest做本地通知。
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            // 必须写代理，不然无法监听通知的接收与点击
            notifiCenter.delegate = self
            let options = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: options) { (_, _) in }
        } else {
            /// iOS 10.0之前使用UILocalNotification做本地通知；
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: - iOS 10.0之后，收到通知 应用在前台时接受到通知
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    // MARK: iOS 10.0之后，通知的点击事件，应用在前台或后台时收到新消息
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
}

