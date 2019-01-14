//
//  SeasonModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 每个时节代表一个定时

import Foundation

struct SeasonModel {
    /// 标题
    var title: String = ""
    /// 备注
    var note: String = ""
    /// 时节时间
    var date: Date = Date()
    /// 显示单位
    var dateUnit: DateUnitType = DateUnitType.dayTime
    /// 是否为公历，true为公历，否则为农历
    var isGregorianCalendar: Bool = true
    /// 是否需要提醒
    var isRemind: Bool = true
    /// 重复提醒
    var repeatRemind: RepeatRemindType = RepeatRemindType.no
    // 主题
    var theme: ThemeModel = ThemeModel()
}
