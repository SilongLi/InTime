//
//  HomeEnum.swift
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


/// 新建“时节” cell id 类型
enum NewSeasonCellIdType: String {
    /// 输入框
    case input
    /// 时间选择
    case timeSelected
    /// 信息选择
    case info
    /// 是否开启提醒
    case reminder
    /// 重复提醒
    case repeatReminder
    /// 自定义背景
    case background
    /// 字体颜色
    case textColor
}

/// 信息选择累心
enum InfoSelectedType {
    /// 显示单位
    case unit
    /// 分类管理
    case classification
    /// 动画效果
    case animation
    /// 提醒铃声
    case ring 
}

/// 自定义背景
enum CustomBackgroundType {
    /// 自定义
    case custom
    /// 默认图片
    case image
    /// 默认颜色
    case color
}
