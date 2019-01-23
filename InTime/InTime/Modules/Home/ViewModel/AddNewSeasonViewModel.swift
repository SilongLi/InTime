//
//  AddNewSeasonViewModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import CoreGraphics

let StartSeasonDateFormat = "yyyy.MM.dd HH:mm"

class AddNewSeasonViewModel {
    
    static let InputCellHeight: CGFloat = 60.0
    static let TimeSelectedCellHeight: CGFloat = 85.0
    static let InfoCellHeight: CGFloat = 44.0
    static let RepeatReminderCellHeight: CGFloat = 90.0
    static let BackgroundCellHeight: CGFloat = 190.0
    static let TextColorCellHeight: CGFloat = 100.0
}

// MARK: - 保存新“时节”
extension AddNewSeasonViewModel {
    /// 添加时节
    static func addNewSeason(season: SeasonModel) -> Bool {
        let seasonJson: Dictionary = season.convertToJson()
        let seasonJsonStr: String = seasonJson.convertToString
        var seasonStrs = [seasonJsonStr]
        if let seasonsData = HandlerDocumentManager.getSeasons(categoryId: season.categoryId) {
            let seasonJsons = NSKeyedUnarchiver.unarchiveObject(with: seasonsData)
            if seasonJsons is Array<String>, let jsonStrs: [String] = seasonJsons as? [String] {
                seasonStrs.append(contentsOf: jsonStrs)
            }
        }
        let seasonsData = NSKeyedArchiver.archivedData(withRootObject: seasonStrs)
        return HandlerDocumentManager.saveSeasons(categoryId: season.categoryId, data: seasonsData)
    }
    
    /// 保存被修改的时节
    static func saveSeason(season: SeasonModel) -> Bool {
        let seasonJson: Dictionary = season.convertToJson()
        let newSeasonJsonStr: String = seasonJson.convertToString
        var seasonStrs = [newSeasonJsonStr]
        if let seasonsData = HandlerDocumentManager.getSeasons(categoryId: season.categoryId) {
            let seasonJsons = NSKeyedUnarchiver.unarchiveObject(with: seasonsData)
            if seasonJsons is Array<String>, var jsonStrs: [String] = seasonJsons as? [String] {
                for index in 0..<jsonStrs.count {
                    let jsonStr = jsonStrs[index]
                    if jsonStr.contains(season.id) {
                        jsonStrs[index] = newSeasonJsonStr
                    }
                }
                seasonStrs = jsonStrs
            }
        }
        let seasonsData = NSKeyedArchiver.archivedData(withRootObject: seasonStrs)
        return HandlerDocumentManager.saveSeasons(categoryId: season.categoryId, data: seasonsData)
    }
}

// MARK: - 创建新建时节的视图布局数据
extension AddNewSeasonViewModel {
    /// 获取新建“时节”列表布局数据
    static func loadListSections(originSeason: SeasonModel, completion: (_ sections: [BaseSectionModel]) -> ()) {
        let isModifySeason = !originSeason.title.isEmpty && !originSeason.categoryId.isEmpty
        
        /// 输入框
        let inputModel = InputModel()
        inputModel.placeholder = "请输入标题"
        if isModifySeason {
            inputModel.text = originSeason.title
        }
        let inputSeason = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.input.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: InputCellHeight,
                                           showCellCount: 1,
                                           items: [inputModel])
        /// 选择“时节”时间
        
        var timeModel = TimeModel()
        if isModifySeason {
            timeModel = originSeason.startDate
        } else {
            timeModel.noteName = "时节时间"
            timeModel.noteIcon = "question"
            timeModel.note = " 提示"
            let date = Date()
            timeModel.lunarDataString = date.solarToLunar()
            timeModel.gregoriandDataString = (date as NSDate).string(withFormat: StartSeasonDateFormat)
            timeModel.isGregorian = true
        }
        let timeSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.timeSelected.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: TimeSelectedCellHeight,
                                           showCellCount: 1,
                                           items: [timeModel])
        /// 显示单位
        var unit  = InfoSelectedModel()
        if isModifySeason {
            unit = originSeason.unitModel
        } else {
            unit.type = InfoSelectedType.unit
            unit.name = "显示单位"
            unit.info = DateUnitType.dayTime.rawValue
        }
        let unitSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.unit.rawValue,
                                           headerTitle: "",
                                           footerTitle: "",
                                           headerHeight: 0.001,
                                           footerHeight: 0.001,
                                           cellHeight: InfoCellHeight,
                                           showCellCount: 1,
                                           items: [unit])
        /// 分类管理
        var categoty: CategoryModel = CategoryModel()
        HomeSeasonViewModel.loadLocalCategorys { (models) in
            for model in models {
                if isModifySeason {
                    if model.id == originSeason.categoryId {
                        categoty = model
                        break
                    }
                } else {
                    if model.isDefalult {
                        categoty = model
                        break
                    }
                }
            }
        }
        let type  = InfoSelectedModel()
        type.id   = categoty.id
        type.type = InfoSelectedType.classification
        type.name = "分类管理"
        type.info = categoty.title
        let typeSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.category.rawValue,
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
        let animationSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.animation.rawValue,
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
        reminder.isOpen = isModifySeason ? originSeason.isOpenRemind : true
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
        ring.name = "提醒铃声"
        if isModifySeason {
            ring.info = originSeason.ringType.rawValue
        } else {
            ring.info = RemindVoiceType.ceilivy.rawValue
        }
        let ringSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.ring.rawValue,
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
        let repeatRemindType = isModifySeason ? originSeason.repeatRemindType : .no
        let no      = RepeatReminderTypeModel(type: .no, title: "不重复", isSelected: repeatRemindType == .no)
        let day     = RepeatReminderTypeModel(type: .day, title: "每天", isSelected: repeatRemindType == .day)
        let week    = RepeatReminderTypeModel(type: .week, title: "每周", isSelected: repeatRemindType == .week)
        let mounth  = RepeatReminderTypeModel(type: .mounth, title: "每月", isSelected: repeatRemindType == .mounth)
        let year    = RepeatReminderTypeModel(type: .year, title: "每年", isSelected: repeatRemindType == .year)
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
        let bgName = isModifySeason ? originSeason.backgroundModel.name : "bg1"
        let empty   = BackgroundImageModel(type: .custom, name: "")
        let image1  = BackgroundImageModel(type: .image, name: "bg1", isSelected: bgName == "bg1")
        let image2  = BackgroundImageModel(type: .image, name: "bg2", isSelected: bgName == "bg2")
        let image3  = BackgroundImageModel(type: .image, name: "bg3", isSelected: bgName == "bg3")
        let image4  = BackgroundImageModel(type: .image, name: "bg4", isSelected: bgName == "bg4")
        let image5  = BackgroundImageModel(type: .image, name: "bg5", isSelected: bgName == "bg5")
        let image6  = BackgroundImageModel(type: .image, name: "bg6", isSelected: bgName == "bg6")
        let image7  = BackgroundImageModel(type: .image, name: "bg7", isSelected: bgName == "bg7")
        let image8  = BackgroundImageModel(type: .image, name: "bg8", isSelected: bgName == "bg8")
        let image9  = BackgroundImageModel(type: .image, name: "bg9", isSelected: bgName == "bg9")
        let image10 = BackgroundImageModel(type: .image, name: "bg10", isSelected: bgName == "bg10")
        let image11 = BackgroundImageModel(type: .image, name: "bg11", isSelected: bgName == "bg11")
        let image12 = BackgroundImageModel(type: .image, name: "bg12", isSelected: bgName == "bg12")
        let image13 = BackgroundImageModel(type: .image, name: "bg13", isSelected: bgName == "bg13")
        let imageColor1 = BackgroundImageModel(type: .color, name: "#FFFFFF", isSelected: bgName == "#FFFFFF")
        let imageColor2 = BackgroundImageModel(type: .color, name: "#55DDFF", isSelected: bgName == "#55DDFF")
        let imageColor3 = BackgroundImageModel(type: .color, name: "#99EBFF", isSelected: bgName == "#99EBFF")
        let imageColor4 = BackgroundImageModel(type: .color, name: "#B2E98E", isSelected: bgName == "#B2E98E")
        let imageColor5 = BackgroundImageModel(type: .color, name: "#E492D4", isSelected: bgName == "#E492D4")
        background.images = [empty, image1, image2, image3, image4, image5, image6, image7, image8, image9, image10, image11, image12, image13, imageColor1, imageColor2, imageColor3, imageColor4, imageColor5]
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
        let colorName = isModifySeason ? originSeason.textColorModel.color : "#FFFFFF"
        let color1 = ColorModel.init(color: "#FFFFFF", isSelected: colorName == "#FFFFFF")
        let color2 = ColorModel.init(color: "#000000", isSelected: colorName == "#000000")
        let color3 = ColorModel.init(color: "#A2A2A2", isSelected: colorName == "#A2A2A2")
        let color4 = ColorModel.init(color: "#FFFF44", isSelected: colorName == "#FFFF44")
        let color5 = ColorModel.init(color: "#FF0099", isSelected: colorName == "#FF0099")
        let color6 = ColorModel.init(color: "#F05731", isSelected: colorName == "#F05731")
        let color7 = ColorModel.init(color: "#11A0FF", isSelected: colorName == "#11A0FF")
        let color8 = ColorModel.init(color: "#0085DD", isSelected: colorName == "#0085DD")
        let color9 = ColorModel.init(color: "#DD00DD", isSelected: colorName == "#DD00DD")
        let color10 = ColorModel.init(color: "#17C7A4", isSelected: colorName == "#17C7A4")
        let color11 = ColorModel.init(color: "#DD8500", isSelected: colorName == "#DD8500")
        color.colors = [color1, color2, color3, color4, color5, color6, color7, color8, color9, color10, color11]
        let colorSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.textColor.rawValue,
                                            headerTitle: "",
                                            footerTitle: "",
                                            headerHeight: 0.001,
                                            footerHeight: 50.0,
                                            cellHeight: TextColorCellHeight,
                                            showCellCount: 1,
                                            items: [color])
        
        completion([inputSeason, timeSection, unitSection, typeSection, reminderSection, ringSection, repeatSection, backgroundSection, colorSection])
    }
    
    /// 获取显示单位数据
    static func loadUnitsModel(originSeason: SeasonModel, completion: ((_ model: AlertCollectionModel) -> ())) {
        let isModifySeason = !originSeason.title.isEmpty && !originSeason.categoryId.isEmpty
        let unitValue = isModifySeason ? originSeason.unitModel.info : DateUnitType.dayTime.rawValue
        
        let second      = TextModel(type: DateUnitType.second.rawValue, text: "秒", isSelected: unitValue == DateUnitType.second.rawValue)
        let minute      = TextModel(type: DateUnitType.minute.rawValue, text: "分", isSelected: unitValue == DateUnitType.minute.rawValue)
        let hour        = TextModel(type: DateUnitType.hour.rawValue, text: "时", isSelected: unitValue == DateUnitType.hour.rawValue)
        let day         = TextModel(type: DateUnitType.day.rawValue, text: "天", isSelected: unitValue == DateUnitType.day.rawValue)
        let dayTime     = TextModel(type: DateUnitType.dayTime.rawValue, text: "天时分秒", isSelected: unitValue == DateUnitType.dayTime.rawValue)
        let year        = TextModel(type: DateUnitType.year.rawValue, text: "年月天", isSelected: unitValue == DateUnitType.year.rawValue)
        let percentage  = TextModel(type: DateUnitType.percentage.rawValue, text: "百分率", isSelected: unitValue == DateUnitType.percentage.rawValue)
        
        let alert = AlertCollectionModel()
        alert.title = "显示单位"
        alert.texts = [second, minute, hour, day, dayTime, year, percentage]
        
        completion(alert)
    }
    
    /// 获取分类数据
    static func loadClassifyModel(originSeason: SeasonModel, completion: ((_ model: AlertCollectionModel) -> ())) {
        HomeSeasonViewModel.loadLocalCategorys { (models) in
            var categorys = [TextModel]()
            for model in models {
                let isModifySeason = !originSeason.title.isEmpty && !originSeason.categoryId.isEmpty
                let isSelected = isModifySeason ? originSeason.categoryId == model.id : model.isDefalult
                let category = TextModel(type: model.id, text: model.title, isSelected: isSelected)
                categorys.append(category)
            }
            
            let alert = AlertCollectionModel()
            alert.title = "分类管理"
            alert.texts = categorys
            
            completion(alert)
        }
    }
    
    /// 获取提醒铃声数据
    static func loadRemindVoicesModel(originSeason: SeasonModel, completion: ((_ model: AlertCollectionModel) -> ())) {
        let isModifySeason = !originSeason.title.isEmpty && !originSeason.categoryId.isEmpty
        let ringType = isModifySeason ? originSeason.ringType : RemindVoiceType.ceilivy
        
        let def      = TextModel(type: RemindVoiceType.defaultType.rawValue, text: "系统默认", isSelected: ringType == RemindVoiceType.defaultType)
        let ceilivy  = TextModel(type: RemindVoiceType.ceilivy.rawValue, text: "Ceilivy", isSelected: ringType == RemindVoiceType.ceilivy)
        let afloat   = TextModel(type: RemindVoiceType.afloat.rawValue, text: "Afloat", isSelected: ringType == RemindVoiceType.afloat)
        let chords   = TextModel(type: RemindVoiceType.chords.rawValue, text: "Chords", isSelected: ringType == RemindVoiceType.chords)
        let together = TextModel(type: RemindVoiceType.together.rawValue, text: "Together", isSelected: ringType == RemindVoiceType.together)
        
        let alert = AlertCollectionModel()
        alert.title = "提醒铃声"
        alert.texts = [def, ceilivy, afloat, chords, together]
        
        completion(alert)
    }
}
