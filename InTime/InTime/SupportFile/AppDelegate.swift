//
//  AppDelegate.swift
//  InTime
//
//  Created by BruceLi on 2019/1/10.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupAppearance()
        
        setupWindow()
        
        HomeSeasonViewModel.initDefaultCategorys()
        
        return true
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
}

