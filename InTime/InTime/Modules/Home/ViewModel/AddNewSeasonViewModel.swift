//
//  AddNewSeasonViewModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation

let StartSeasonDateFormat = "yyyy.MM.dd HH:mm"
let StartSeasonDateMDHMFormat = "MM.dd HH:mm"
let StartSeasonDateDHMFormat = "dd HH:mm"
let StartSeasonDateHMFormat = "HH:mm"

/// 首页闹铃模块
public let HomeRingSeasonsKey: String = "HomeRingSeasonsKey"

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
        if let seasonsData = HandleAppGroupsDocumentMannager.getSeasons(seasonType: HomeRingSeasonsKey) {
            let seasonJsons = NSKeyedUnarchiver.unarchiveObject(with: seasonsData)
            if seasonJsons is Array<String>, let jsonStrs: [String] = seasonJsons as? [String] {
                seasonStrs.append(contentsOf: jsonStrs)
            }
        }
        let seasonsData = NSKeyedArchiver.archivedData(withRootObject: seasonStrs)
        return HandleAppGroupsDocumentMannager.saveSeasons(seasonType: HomeRingSeasonsKey, data: seasonsData)
    }
    
    /// 保存所有时节
    @discardableResult
    static func saveAllSeasons(seasons: [SeasonModel]) -> Bool {
        guard seasons.isEmpty == false else {
            return false
        }
        var seasonStrs: [String] = [String]()
        for season in seasons {
            let seasonJson: Dictionary = season.convertToJson()
            let seasonJsonStr: String = seasonJson.convertToString
            seasonStrs.append(seasonJsonStr)
        }
        let seasonsData = NSKeyedArchiver.archivedData(withRootObject: seasonStrs)
        return HandleAppGroupsDocumentMannager.saveSeasons(seasonType: HomeRingSeasonsKey, data: seasonsData)
    }
    
    /// 保存被修改的时节
    static func saveSeason(season: SeasonModel) -> Bool {
        let seasonJson: Dictionary = season.convertToJson()
        let newSeasonJsonStr: String = seasonJson.convertToString
        var seasonStrs = [newSeasonJsonStr]
        if let seasonsData = HandleAppGroupsDocumentMannager.getSeasons(seasonType: HomeRingSeasonsKey) {
            let seasonJsons = NSKeyedUnarchiver.unarchiveObject(with: seasonsData)
            if seasonJsons is Array<String>, var jsonStrs: [String] = seasonJsons as? [String] {
                for index in 0..<jsonStrs.count {
                    let jsonStr = jsonStrs[index]
                    if jsonStr.contains(season.id) {
                        jsonStrs[index] = newSeasonJsonStr
                        break
                    }
                }
                seasonStrs = jsonStrs
            }
        }
        let seasonsData = NSKeyedArchiver.archivedData(withRootObject: seasonStrs)
        return HandleAppGroupsDocumentMannager.saveSeasons(seasonType: HomeRingSeasonsKey, data: seasonsData)
    }
    
    /// 删除时节
    static func deleteSeason(season: SeasonModel) -> Bool {
        guard !season.id.isEmpty else {
            return false
        }
        if let seasonsData = HandleAppGroupsDocumentMannager.getSeasons(seasonType: HomeRingSeasonsKey) {
            let seasonJsons = NSKeyedUnarchiver.unarchiveObject(with: seasonsData)
            if seasonJsons is Array<String>, var jsonStrs: [String] = seasonJsons as? [String] {
                for index in 0..<jsonStrs.count {
                    let jsonStr = jsonStrs[index]
                    if jsonStr.contains(season.id) {
                        jsonStrs.remove(at: index)
                        break
                    }
                }
                let seasonsData = NSKeyedArchiver.archivedData(withRootObject: jsonStrs)
                return HandleAppGroupsDocumentMannager.saveSeasons(seasonType: HomeRingSeasonsKey, data: seasonsData)
            }
        }
        return false
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
            let date: Date = NSDate(minutesFromNow: 5) as Date
            timeModel.weakDay = date.weekDay()
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
        var category: CategoryModel = CategoryModel()
        HomeSeasonViewModel.loadLocalCategorys { (models) in
            // 默认类型不添加时节
            var categorys = models
            for index in 0..<models.count {
                let model = models[index]
                if model.isDefault {
                    categorys.remove(at: index)
                    if model.isSelected, var first = categorys.first {
                        first.isSelected = true
                        categorys[0] = first
                    }
                    break
                }
            }
            for model in categorys {
                if isModifySeason {
                    if model.id == originSeason.categoryId {
                        category = model
                        break
                    }
                } else {
                    if model.isSelected {
                        category = model
                        break
                    }
                }
            }
        }
        let type  = InfoSelectedModel()
        type.id   = category.id
        type.type = InfoSelectedType.classification
        type.name = "分类管理"
        type.info = category.title
        let categorySection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.category.rawValue,
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
        if isModifySeason {
            animation.info = originSeason.animationType.desc()
        } else {
            animation.info = "坠落"
        }
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
        let workDay = RepeatReminderTypeModel(type: .workDay, title: "工作日", isSelected: repeatRemindType == .workDay)
        let week    = RepeatReminderTypeModel(type: .week, title: "每周", isSelected: repeatRemindType == .week)
        let month  = RepeatReminderTypeModel(type: .month, title: "每月", isSelected: repeatRemindType == .month)
        let year    = RepeatReminderTypeModel(type: .year, title: "每年", isSelected: repeatRemindType == .year)
        let commemorationDay = RepeatReminderTypeModel(type: .commemorationDay, title: "纪念日", isSelected: repeatRemindType == .commemorationDay)
        repeatModel.types = [no, day, workDay, week, month, year, commemorationDay]
        let repeatSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.repeatReminder.rawValue,
                                             headerTitle: "",
                                             footerTitle: "",
                                             headerHeight: 0.001,
                                             footerHeight: 0.001,
                                             cellHeight: RepeatReminderCellHeight,
                                             showCellCount: 1,
                                             items: [repeatModel])
        
        /// 自定义背景
        let isSelectedCustom = originSeason.backgroundModel.type == .custom
        let bgName  = isModifySeason ? originSeason.backgroundModel.name : "bg1"
        let empty   = BackgroundImageModel(type: .custom, name: isModifySeason ? originSeason.id : "", isSelected: isSelectedCustom)
        
        let bgImageTypes = ["bg1",
                            "bg2",
                            "bg3",
                            "bg4",
                            "bg5",
                            "bg6",
                            "bg7",
                            "bg8",
                            "bg9",
                            "bg10",
                            "bg11",
                            "bg12",
                            "bg13",
                            "bg14",
                            "bg15",
                            "bg16",
                            "bg17",
                            "bg18",
                            "bg19",
                            "bg20",
                            "bg21",
                            "bg22",
                            "bg23"]
        var imageModels = [BackgroundImageModel]()
        for type in bgImageTypes {
            let model = BackgroundImageModel(type: .image, name: type, isSelected: bgName == type)
            imageModels.append(model)
        }
        
        let bgColorTypes = ["#000000",
                            "#55DDFF",
                            "#B2E98E",
                            "#F0C432",
                            "#7FD5D3",
                            "#B1948C",
                            "#F9A751",
                            "#666A7D"]
        var bgColorModels = [BackgroundImageModel]()
        for type in bgColorTypes {
            let model = BackgroundImageModel(type: .color, name: type, isSelected: bgName == type)
            bgColorModels.append(model)
        }
        
        /// 如果不是修改已有“时节”，则随机选中背景图片
        var bgImages = [empty]
        if !isModifySeason {
            let randomIndex = Int.random(in: 0..<imageModels.count)
            for index in 0..<imageModels.count {
                let image = imageModels[index]
                image.isSelected = index == randomIndex
                imageModels[index] = image
            }
        }
        bgImages.append(contentsOf: imageModels)
        bgImages.append(contentsOf: bgColorModels)
        
        let background  = BackgroundModel()
        background.name = "自定义背景"
        background.images = bgImages
        
        let backgroundSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.background.rawValue,
                                                 headerTitle: "",
                                                 footerTitle: "",
                                                 headerHeight: 0.001,
                                                 footerHeight: 0.001,
                                                 cellHeight: BackgroundCellHeight,
                                                 showCellCount: 1,
                                                 items: [background])
        /// 字体颜色
        let colorName = isModifySeason ? originSeason.textColorModel.color : "#FFFFFF"
        let types = ["#FFFFFF",
                     "#000000",
                     "#A2A2A2",
                     "#B2E98E",
                     "#FFFF44",
                     "#FF0099",
                     "#F05731",
                     "#11A0FF",
                     "#0085DD",
                     "#DD00DD",
                     "#17C7A4",
                     "#DD8500",
                     "#666A7D"]
        var colorModels = [ColorModel]()
        for type in types {
            let model = ColorModel(color: type, isSelected: colorName == type)
            colorModels.append(model)
        }
        
        let textColorModel  = TextColorModel()
        textColorModel.name = "字体颜色"
        textColorModel.colors = colorModels
        
        let colorSection = BaseSectionModel(cellIdentifier: NewSeasonCellIdType.textColor.rawValue,
                                            headerTitle: "",
                                            footerTitle: "",
                                            headerHeight: 0.001,
                                            footerHeight: 50.0,
                                            cellHeight: TextColorCellHeight,
                                            showCellCount: 1,
                                            items: [textColorModel])
        
        completion([inputSeason, timeSection, unitSection, categorySection, animationSection, reminderSection, repeatSection, backgroundSection, colorSection])
    }
    
    // MARK: - 获取显示单位数据
    static func loadUnitsModel(originSeason: SeasonModel, completion: ((_ model: AlertCollectionModel) -> ())) {
        let isModifySeason = !originSeason.title.isEmpty && !originSeason.categoryId.isEmpty
        let unitValue = isModifySeason ? originSeason.unitModel.info : DateUnitType.dayTime.rawValue

        let types = [DateUnitType.second,
                     DateUnitType.minute,
                     DateUnitType.hour,
                     DateUnitType.day,
                     DateUnitType.weak,
                     DateUnitType.dayTime,
                     DateUnitType.year,
                     DateUnitType.yearTime
//                    , DateUnitType.percentage // 暂不支持
                    ]
        var textModels = [TextModel]()
        for type in types {
            let model = TextModel(type: type.rawValue, text: type.rawValue, isSelected: unitValue == type.rawValue)
            textModels.append(model)
        }
        
        let alert = AlertCollectionModel()
        alert.title = "显示单位"
        alert.texts = textModels
        
        completion(alert)
    }
    
    // MARK: - 获取分类数据
    static func loadClassifyModel(originSeason: SeasonModel, completion: ((_ model: AlertCollectionModel, _ categoryModels: [CategoryModel]) -> ())) {
        HomeSeasonViewModel.loadLocalCategorys { (models) in
            // 默认类型不添加时节
            var categorys = models
            for index in 0..<models.count {
                let model = models[index]
                if model.isDefault {
                    categorys.remove(at: index)
                    if model.isSelected, var first = categorys.first {
                        first.isSelected = true
                        categorys[0] = first
                    }
                    break
                }
            }
            let alert = AddNewSeasonViewModel.handleClassifyModel(originSeason: originSeason, categorys)
            completion(alert, categorys)
        }
    }
    
    static func handleClassifyModel(originSeason: SeasonModel, _ models: [CategoryModel]) -> AlertCollectionModel {
        var textModels = [TextModel]()
        for model in models {
            let textModel = TextModel(type: model.id, text: model.title, isSelected: model.isSelected)
            textModels.append(textModel)
        }
        let alert = AlertCollectionModel()
        alert.title = "分类管理"
        alert.texts = textModels
        return alert
    }
    
    // MARK: - 获取动画效果数据
    static func loadAnimationModels(originSeason: SeasonModel, completion: ((_ model: AlertCollectionModel) -> ())) {
        let isModifySeason = !originSeason.title.isEmpty && !originSeason.categoryId.isEmpty
        let animationType = isModifySeason ? originSeason.animationType : CountdownEffect.Fall
        
        let types = [CountdownEffect.None,
                    CountdownEffect.Burn,
                    CountdownEffect.Evaporate,
                    CountdownEffect.Fall,
                    CountdownEffect.Pixelate,
                    CountdownEffect.Scale,
                    CountdownEffect.Sparkle,
                    CountdownEffect.Anvil]
        var textModels = [TextModel]()
        for type in types {
            let model = TextModel(type: type.rawValue, text: type.desc(), isSelected: animationType == type)
            textModels.append(model)
        }
        
        let alert = AlertCollectionModel()
        alert.title = "动画效果"
        alert.texts = textModels
        
        completion(alert)
    }
    
    // MARK: - 获取提醒铃声数据
    static func loadRemindVoicesModel(originSeason: SeasonModel, completion: ((_ model: AlertCollectionModel) -> ())) {
        let isModifySeason = !originSeason.title.isEmpty && !originSeason.categoryId.isEmpty
        let ringType = isModifySeason ? originSeason.ringType : RemindVoiceType.ceilivy

        let types = [RemindVoiceType.defaultType,
                     RemindVoiceType.ceilivy,
                     RemindVoiceType.afloat,
                     RemindVoiceType.chords,
                     RemindVoiceType.together]
        var textModels = [TextModel]()
        for type in types {
            let model = TextModel(type: type.rawValue, text: type.rawValue, isSelected: ringType == type)
            textModels.append(model)
        }
        
        let alert = AlertCollectionModel()
        alert.title = "提醒铃声"
        alert.texts = textModels
        
        completion(alert)
    }
}
