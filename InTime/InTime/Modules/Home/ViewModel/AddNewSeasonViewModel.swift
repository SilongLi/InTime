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
    static let RepeatReminderCellHeight: CGFloat = 90.0
    static let BackgroundCellHeight: CGFloat = 190.0
    static let TextColorCellHeight: CGFloat = 100.0

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
        repeatModel.name = "重复提醒"
        let no      = RepeatReminderTypeModel(type: .no, title: "不重复", isSelected: true)
        let day     = RepeatReminderTypeModel(type: .day, title: "每天")
        let week    = RepeatReminderTypeModel(type: .week, title: "每周")
        let mounth  = RepeatReminderTypeModel(type: .mounth, title: "每月")
        let year    = RepeatReminderTypeModel(type: .year, title: "每年")
        repeatModel.types = [no, day, week, mounth, year]
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
        background.name = "自定义背景"
        let empty  = BackgroundImageModel(type: .custom, name: "")
        let image1 = BackgroundImageModel(type: .image, name: "night", isSelected: true)
        let image2 = BackgroundImageModel(type: .image, name: "mountain")
        let image3 = BackgroundImageModel(type: .image, name: "rail")
        let image4 = BackgroundImageModel(type: .image, name: "snow")
        let image5 = BackgroundImageModel(type: .image, name: "sunsetGlow")
        let image6 = BackgroundImageModel(type: .image, name: "flower")
        let imageColor1 = BackgroundImageModel(type: .color, name: "#FFFFFF")
        let imageColor2 = BackgroundImageModel(type: .color, name: "#55DDFF")
        let imageColor3 = BackgroundImageModel(type: .color, name: "#99EBFF")
        let imageColor4 = BackgroundImageModel(type: .color, name: "#B2E98E")
        let imageColor5 = BackgroundImageModel(type: .color, name: "#E492D4")
        background.images = [empty, image1, image2, image3, image4, image5, image6, imageColor1, imageColor2, imageColor3, imageColor4, imageColor5]
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
        color.name = "字体颜色"
        let color1 = ColorModel.init(color: "#FFFFFF", isSelected: true)
        let color2 = ColorModel.init(color: "#000000")
        let color3 = ColorModel.init(color: "#A2A2A2")
        let color4 = ColorModel.init(color: "#FFFF44")
        let color5 = ColorModel.init(color: "#FF0099")
        let color6 = ColorModel.init(color: "#F05731")
        let color7 = ColorModel.init(color: "#11A0FF")
        let color8 = ColorModel.init(color: "#0085DD")
        let color9 = ColorModel.init(color: "#DD00DD")
        let color10 = ColorModel.init(color: "#17C7A4")
        let color11 = ColorModel.init(color: "#DD8500")
        color.colors = [color1, color2, color3, color4, color5, color6, color7, color8, color9, color10, color11]
        let colorSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.textColor.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 50.0,
                                           cellHeight: TextColorCellHeight,
                                           showCellCount: 1,
                                           items: [color])
        
        completion([inputSeason, timeSection, unitSection, typeSection, animationSection, reminderSection, ringSection, repeatSection, backgroundSection, colorSection])
    }
}
