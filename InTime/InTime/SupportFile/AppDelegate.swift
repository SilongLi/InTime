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
        /// iOS 10.0之前使用UILocalNotification做本地通知；
        /// iOS 10.0之后使用UNNotificationRequest做本地通知。
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            // 必须写代理，不然无法监听通知的接收与点击
            notifiCenter.delegate = self
            
            let options = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: options) { (flag, error) in
                if flag {
                    print("本地通知成功")
                } else {
                    print("本地通知失败")
                }
            }
            
//            notifiCenter.requestAuthorization(options: options) { (flag, error) in
//                if flag {
//                    let action1 = UNNotificationAction.init(identifier: "action1", title: "启动app", options: UNNotificationActionOptions.foreground)
//
//                    //创建动作(按钮)的类别集合
//                    let category = UNNotificationCategory.init(identifier: "category", actions: [action1], intentIdentifiers: ["action1"], options: UNNotificationCategoryOptions.customDismissAction)
//                    notifiCenter.setNotificationCategories(Set<UNNotificationCategory>([category]))
//                    notifiCenter.getNotificationSettings(completionHandler: { (settings) in
//                        print(settings)
//                    })
//                } else {
//                    print(" iOS 10 request notification fail")
//                }
//            }
        } else {
            let action = UIMutableUserNotificationAction()
            action.identifier = "action1"
            action.title = "启动app"
            action.activationMode = .foreground
            action.isDestructive = true
            
            let category = UIMutableUserNotificationCategory()
            category.identifier = "category"
            category.setActions([action], for: (.default))
            
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        // 注册获得device Token
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: - iOS 10.0之后，收到通知 应用在前台时接受到通知
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 需要执行这个方法，选择是否提醒用户，有sound、alert、badge三种类型可以设置
        completionHandler([.alert, .sound, .badge])
    }
    
    // MARK: iOS 10.0之后，通知的点击事件，应用在前台或后台时收到新消息
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        /// 在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据actionIdentifier来判断点击的哪个按钮
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        /// 取消闹铃
        let request = response.notification.request
        let title   =  request.content.title
        LocalNotificationManage.shared.cancelLocalNotification(identifier: request.identifier, title: title)
        
        completionHandler()
    }
}

