//
//  AddNewSeasonViewModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import CoreGraphics

class AddNewSeasonViewModel {
    
    static let InputCellHeight: CGFloat = 60.0
    static let TimeSelectedCellHeight: CGFloat = 85.0
    static let InfoCellHeight: CGFloat = 44.0
    static let RepeatReminderCellHeight: CGFloat = 60.0
    static let BackgroundCellHeight: CGFloat = 120.0
    static let TextColorCellHeight: CGFloat = 60.0

    /// 获取新建“时节”列表布局数据
    static func loadListSections(completion: (_ sections: [BaseSectionModel]) -> ()) {
        /// 输入框
        let inputModel = InputModel()
        inputModel.placeholder = "  请输入标题"
        let inputSeason = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.input.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: InputCellHeight,
                                           showCellCount: 1,
                                           items: [inputModel])
        /// 选择“时节”时间
        let timeModel = TimeModel()
        timeModel.noteName = "时节时间"
        timeModel.noteIcon = "question"
        timeModel.note = " 提示"
        
        timeModel.dataString = "2019.01.15 15:00"
        timeModel.isGregorian = true
        let timeSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.timeSelected.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: TimeSelectedCellHeight,
                                           showCellCount: 1,
                                           items: [timeModel])
        /// 显示单位
        let unit  = InfoSelectedModel()
        unit.type = InfoSelectedType.unit
        unit.name = "显示单位"
        unit.info = "天时分秒"
        let unitSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.info.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: InfoCellHeight,
                                           showCellCount: 1,
                                           items: [unit])
        /// 分类管理
        let type  = InfoSelectedModel()
        type.type = InfoSelectedType.classification
        type.name = "分类管理"
        type.info = "全部"
        let typeSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.info.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: InfoCellHeight,
                                           showCellCount: 1,
                                           items: [type])
        /// 动画效果
        let animation  = InfoSelectedModel()
        animation.type = InfoSelectedType.animation
        animation.name = "动画效果"
        animation.info = "自动"
        let animationSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.info.rawValue,
                                                headerTitle: "",
                                                footerTitle: "",
                                                headerHeight: 0.001,
                                                footerHeight: 0.001,
                                                cellHeight: InfoCellHeight,
                                                showCellCount: 1,
                                                items: [animation])
        
        /// 是否开启“时节”提醒
        let reminder = OpenReminderModel()
        reminder.name = "时节提醒"
        reminder.isOpen = true
        let reminderSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.reminder.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: InfoCellHeight,
                                           showCellCount: 1,
                                           items: [reminder])
 
        /// 提醒铃声
        let ring  = InfoSelectedModel()
        ring.type = InfoSelectedType.ring
        ring.name = "动画效果"
        ring.info = "自动"
        let ringSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.info.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: InfoCellHeight,
                                           showCellCount: 1,
                                           items: [ring])
        /// 重复提醒
        let repeatModel = RepeatReminderModel()
        repeatModel.name = "动画效果"
        repeatModel.types = ["不重复", "每天", "每周", "每月", "每年"]
        let repeatSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.repeatReminder.rawValue,
                                             headerTitle: "",
                                             footerTitle: "",
                                             headerHeight: 0.001,
                                             footerHeight: 0.001,
                                             cellHeight: RepeatReminderCellHeight,
                                             showCellCount: 1,
                                             items: [repeatModel])
        /// 自定义背景
        let background  = BackgroundModel()
        background.name = "动画效果"
        background.images = [""]
        let backgroundSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.background.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: BackgroundCellHeight,
                                           showCellCount: 1,
                                           items: [background])
        /// 字体颜色
        let color  = TextColorModel()
        color.name = "动画效果"
        color.colors = [""]
        let colorSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.textColor.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: TextColorCellHeight,
                                           showCellCount: 1,
                                           items: [color])
        
        completion([inputSeason, timeSection, unitSection, typeSection, animationSection, reminderSection, ringSection, repeatSection, backgroundSection, colorSection])
    }
}
