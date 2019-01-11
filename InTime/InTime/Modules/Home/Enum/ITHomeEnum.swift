//
//  ITHomeEnum.swift
//  InTime
//
//  Created by lisilong on 2019/1/11.
//  Copyright © 2019 BruceLi. All rights reserved.
//

// MARK: - 重复提醒类型
enum RepeatRemindType {
    /// 不重复
    case no
    /// 每天
    case day
    /// 每周
    case week
    /// 每月
    case mounth
    /// 每年
    case year
}

/// 显示时间的单位
enum DateUnitType: String {
    /// 秒
    case second     = "秒"
    /// 分
    case minute     = "分"
    /// 时
    case hour       = "时"
    /// 天
    case day        = "天"
    /// 天时分秒
    case dayTime    = "天时分秒"
    /// 年月天
    case year       = "年月天"
    /// 百分率
    case percentage = "百分率"
}
