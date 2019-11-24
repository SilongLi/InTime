//
//  ITViewMacros.swift
//  CloudKeeper
//
//  Created by BruceLi on 2018/8/15.
//  Copyright © 2018 BruceLi. All rights reserved.
//

import UIKit 

let IT_SCREEN_WIDTH = (UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.height: UIScreen.main.bounds.width)
let IT_SCREEN_HEIGHT = (UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.width: UIScreen.main.bounds.height)

let IT_APP_WINDOW = UIApplication.shared.keyWindow!

// 屏幕尺寸适配
let IT_IPHONE_4 = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 640, height: 960), (UIScreen.main.currentMode?.size)!) : false
let IT_IPHONE_5 = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 640, height: 1136), (UIScreen.main.currentMode?.size)!) : false
let IT_IPHONE_6 = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 750, height: 1334), (UIScreen.main.currentMode?.size)!) : false
let IT_IPHONE_6P = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1242, height: 2208), (UIScreen.main.currentMode?.size)!) : false
let IT_IPHONE_6PBigMode = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1125, height: 2001), (UIScreen.main.currentMode?.size)!) : false

/// 目前iPhoneX系列都是“刘海屏”，状态栏的高度均为44.0
let IT_IPHONE_X: Bool = {
    return UIApplication.shared.statusBarFrame.size.height == 44.0
}()

let IT_NaviHeight: CGFloat   = IT_IPHONE_X ? 88 : 64
let IT_TabbarHeight: CGFloat = IT_IPHONE_X ? 83 : 49
let IT_StatusHeight: CGFloat = IT_IPHONE_X ? 44 : 20

let suitParm: CGFloat = (IT_IPHONE_6P ? 1.12 : (IT_IPHONE_6 ? 1.0 : (IT_IPHONE_6PBigMode ? 1.01 : (IT_IPHONE_X ? 1.0 : 0.85))))

func RGB (r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

func RGBA (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
