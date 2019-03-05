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
    /// 唯一标识
    var id: String = ""
    /// 所属类别
    var categoryId: String = ""
    /// 标题
    var title: String = ""
    /// 时节时间
    var startDate: TimeModel = TimeModel()
    /// 显示单位
    var unitModel: InfoSelectedModel = InfoSelectedModel()
    /// 是否开启闹铃提醒
    var isOpenRemind: Bool = true
    /// 提醒铃声
    var ringType: RemindVoiceType = RemindVoiceType.defaultType
    /// 重复提醒类型
    var repeatRemindType: RepeatRemindType = RepeatRemindType.no
    /// 自定义背景
    var backgroundModel: BackgroundImageModel = BackgroundImageModel()
    /// 字体颜色
    var textColorModel: ColorModel = ColorModel()
    
    /// 是否已经取消本地通知
    var hasCancelNotification: Bool = false
}

extension SeasonModel {
    static func convertToModel(json: JSON) -> SeasonModel {
        var model = SeasonModel()
        model.id                = json["id"].stringValue
        model.categoryId        = json["categoryId"].stringValue
        model.title             = json["title"].stringValue
        model.isOpenRemind      = json["isOpenRemind"].boolValue
        model.ringType          = RemindVoiceType(rawValue: json["ringType"].stringValue) ?? RemindVoiceType.defaultType
        model.repeatRemindType  = RepeatRemindType(rawValue: json["repeatRemindType"].stringValue) ?? RepeatRemindType.no
        model.startDate         = TimeModel.convertToModel(json: JSON(parseJSON: json["startDate"].stringValue))
        model.unitModel         = InfoSelectedModel.convertToModel(json: JSON(parseJSON: json["unitModel"].stringValue))
        model.backgroundModel   = BackgroundImageModel.convertToModel(json: JSON(parseJSON: json["backgroundModel"].stringValue))
        model.textColorModel    = ColorModel.convertToModel(json: JSON(parseJSON: json["textColorModel"].stringValue))
        model.hasCancelNotification = json["hasCancelNotification"].boolValue
        return model
    }
    
    func convertToJson() -> Dictionary<String, Any> {
        let startDateStr = startDate.convertToJson().convertToString
        let unitModelStr = unitModel.convertToJson().convertToString
        let backgroundModelStr = backgroundModel.convertToJson().convertToString
        let textColorModelStr  = textColorModel.convertToJson().convertToString
        return ["id": id,
                "categoryId": categoryId,
                "title": title,
                "startDate": startDateStr,
                "unitModel": unitModelStr,
                "isOpenRemind": isOpenRemind,
                "ringType": ringType.rawValue,
                "repeatRemindType": repeatRemindType.rawValue,
                "backgroundModel": backgroundModelStr,
                "textColorModel": textColorModelStr,
                "hasCancelNotification": hasCancelNotification]
    }
}
