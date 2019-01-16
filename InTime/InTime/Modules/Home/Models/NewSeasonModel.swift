//
//  NewSeasonModel.swift
//  InTime
//
//  Created by lisilong on 2019/1/15.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 新建“时节”
import Foundation

/// 输入框
class InputModel: BaseModel {
    var placeholder: String = ""
    var text: String = ""
}

/// 时间选择
class TimeModel: BaseModel {
    /// 事件提示
    var noteName: String = ""
    var noteIcon: String = ""
    var note: String = ""
    
    var data: Date = Date()
    var dataString: String = ""
    /// isGregorian 表示是否为公历true，false为农历
    var isGregorian: Bool = true
}

/// 信息选择
class InfoSelectedModel: BaseModel {
    var type: InfoSelectedType = InfoSelectedType.unit
    var name: String = ""
    var info: String = ""
}

/// 是否开启"时节"提醒
class OpenReminderModel: BaseModel {
    var name: String = ""
    var isOpen: Bool = true
}

/// 重复提醒
class RepeatReminderModel: BaseModel {
    var name: String = ""
    var types: [RepeatReminderTypeModel] = [RepeatReminderTypeModel]()
}

class RepeatReminderTypeModel: BaseModel {
    var type: RepeatRemindType = RepeatRemindType.no
    var title: String = ""
    var isSelected: Bool = false
    init(type: RepeatRemindType, title: String, isSelected: Bool = false) {
        self.type = type
        self.title = title
        self.isSelected = isSelected
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

/// 自定义背景
class BackgroundModel: BaseModel {
    var name: String = ""
    var images: [BackgroundImageModel] = [BackgroundImageModel]()
}

class BackgroundImageModel: BaseModel {
    var type: CustomBackgroundType = CustomBackgroundType.image
    var name: String = ""
    var isSelected: Bool = false
    init(type: CustomBackgroundType, name: String, isSelected: Bool = false) {
        self.type = type
        self.name = name
        self.isSelected = isSelected
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

/// 字体颜色
class TextColorModel: BaseModel {
    var name: String = ""
    var colors: [ColorModel] = [ColorModel]()
}

class ColorModel: BaseModel {
    var color: String = ""
    var isSelected: Bool = false
    init(color: String, isSelected: Bool = false) {
        self.color = color
        self.isSelected = isSelected
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
