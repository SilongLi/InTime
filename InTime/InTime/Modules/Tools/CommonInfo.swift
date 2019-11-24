//
//  HandleDateManager.swift
//  InTime
//
//  Created by lisilong on 2019/1/23.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 第三方账号信息
/// Bugly app id/key
public let BuglyAPPID: String = "d94f44dd71"
public let BuglyAPPKEY: String = "8ecf65ee-58c2-46e0-b37e-677168ff1d11"


// MARK: - Notification

/// 新增“时节”
public let NotificationAddNewSeason: Notification.Name = Notification.Name("Notification_Add_New_Season")
/// 更新“时节”分类
public let NotificationUpdateSeasonCategory: Notification.Name = Notification.Name("Notification_Update_Season_Category")


// MARK: - 字体
public let FontName = "KohinoorBangla-Semibold"
public let TimeNumberFontName = "DBLCDTempBlack"
public let TimeNumberFontSize: CGFloat = 14 


// MARK: - UserDefault
/// 是否开启磨砂效果
public let IsOpenBlurEffect: String = "IsOpenBlurEffect"

// 首页
public let Margin: CGFloat = 15.0
public let IconWH: CGFloat = 16.0
public let SeasonNumberGotoComment = 5

// 当前选中时节类型
let CurrentSelectedCategoryIDKey = "CurrentSelectedCategoryID"


// MARK: - 其它

public let StartSeasonDateFormat = "yyyy.MM.dd HH:mm"
public let StartSeasonDateMDHMFormat = "MM.dd HH:mm"
public let StartSeasonDateDHMFormat = "dd HH:mm"
public let StartSeasonDateHMFormat = "HH:mm"
/// 首页闹铃模块
public let HomeRingSeasonsKey: String = "HomeRingSeasonsKey"

public let IncomeTodayWidgetSchema = "IncomeTodayWidget://"
