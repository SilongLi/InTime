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
    /// 所属类别
    var categoryModel: CategoryModel = CategoryModel()
    /// 标题
    var title: String = ""
    /// 时节时间
    var startDate: TimeModel = TimeModel()
    /// 显示单位
    var unitModel: InfoSelectedModel = InfoSelectedModel()
    /// 是否开启闹铃提醒
    var isOpenRemind: Bool = true
    /// 重复提醒类型
    var repeatRemindType: RepeatRemindType = RepeatRemindType.no
    /// 自定义背景
    var backgroundModel: BackgroundImageModel = BackgroundImageModel()
    /// 字体颜色
    var textColorModel: ColorModel = ColorModel()
}
