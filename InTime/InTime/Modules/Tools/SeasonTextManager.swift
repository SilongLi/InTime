//
//  SeasonTextManager.swift
//  InTime
//
//  Created by lisilong on 2019/2/25.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 时节视图文案处理


class SeasonTextManager {
    
    /// 动画时间格式
    static func handleDateFormat(type: DateUnitType = DateUnitType.dayTime) -> String {
        switch type {
        case .second:
            return "ss秒"
        case .minute:
            return "mm分"
        case .hour:
            return "HH时"
        case .day:
            return "dd天"
        case .dayTime:
            return "dd天HH时mm分ss秒"
        case .year:
            return "yy年mm月dd天"
        case .yearTime:
            return "yy年mm月dd天HH时mm分ss秒"
        case .percentage:
            return ""
        }
    }

    static func handleSeasonInfo(_ season: SeasonModel) -> (String, info: String, date: Date, dateInfo: String, isLater: Bool) {
        var timeIntervalString = "--"
        var info = "距离"
        var dateInfo = "--"
        // 闹铃日期是否在当前时间之后
        var isLater = true
        
        guard var date = NSDate(season.startDate.gregoriandDataString, withFormat: StartSeasonDateFormat) else {
            return (timeIntervalString, info, Date(), dateInfo, isLater)
        }
        // 倒计时显示类型
        let type: DateUnitType = DateUnitType(rawValue: season.unitModel.info) ?? DateUnitType.dayTime
        isLater = date.isLaterThanDate(Date())
        
        switch season.repeatRemindType {
        case .year:
            if isLater == false {
                let yearCount = (NSDate()).year - date.year
                date = isLater ? date : date.addingYears(yearCount + 1) as NSDate
            }
            
            var dateStr = ""
            if season.startDate.isGregorian {
                dateStr = date.string(withFormat: StartSeasonDateFormat)
            } else {
                dateStr = (date as Date).solarToLunar()
            }
            dateInfo = "\(dateStr) \(season.startDate.weakDay)"
            
        case .week:
            if isLater == false {
                let count = date.distanceInDays(to: Date())
                date = date.addingDays(count + (7 - Int(count % 7))) as NSDate
            }
            
            let dateStr: String = date.string(withFormat: StartSeasonDateHMFormat)
            dateInfo = "\(dateStr) \((date as Date).weekDay())"
            break
        case .workDay:
            if isLater == false {
                let count = date.distanceInDays(to: Date())
                date = date.addingDays(count + 1) as NSDate
            }
            let dateStr: String = date.string(withFormat: StartSeasonDateHMFormat)
            dateInfo = "\(dateStr) \((date as Date).weekDay())"
            
        case .day:
            if isLater == false {
                let count = date.distanceInDays(to: Date())
                date = date.addingDays(count + 1) as NSDate
            }
            let dateStr: String = date.string(withFormat: StartSeasonDateHMFormat)
            dateInfo = "\(dateStr) \((date as Date).weekDay())"
            
        default: // 默认
            info = isLater ? "距离" : "已过"
            
            var dateStr = ""
            if season.startDate.isGregorian {
                dateStr = season.startDate.gregoriandDataString
            } else {
                dateStr = season.startDate.lunarDataString
            }
            dateInfo = "\(dateStr) \(season.startDate.weakDay.isEmpty ? (date as Date).weekDay() : season.startDate.weakDay)"
        }
        
        isLater = date.isLaterThanDate(Date())
        timeIntervalString = (date as Date).convertToTimeAndUnitString(type: type)
        return (timeIntervalString, info, date as Date, dateInfo, isLater)
    }
}
