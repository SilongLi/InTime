//
//  SeasonTextManager.swift
//  InTime
//
//  Created by lisilong on 2019/2/25.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 时节视图文案处理


class SeasonTextManager {

    static func handleSeasonInfo(_ season: SeasonModel, isNeedWeekDayInfo: Bool = true) -> (String, date: NSDate, dateInfo: String, isLater: Bool) {
        var timeIntervalString = "--"
        var dateInfo = "--"
        // 闹铃日期是否在当前时间之后
        var isLater = true
        
        guard var date = NSDate(season.startDate.gregoriandDataString, withFormat: StartSeasonDateFormat) else {
            return (timeIntervalString, NSDate(), dateInfo, isLater)
        }
        // 倒计时显示类型
        let type: DateUnitType = DateUnitType(rawValue: season.unitModel.info) ?? DateUnitType.dayTime
        isLater = date.isLaterThanDate(Date())
        
        switch season.repeatRemindType {
        case .year:
            if isLater == false {
                var yearCount = (NSDate()).year - date.year
                if (NSDate().month > date.month) ||
                    (NSDate().month == date.month && NSDate().day > date.day) {
                    yearCount += 1
                }
                date = isLater ? date : date.addingYears(yearCount) as NSDate
            }
            
            var dateStr = ""
            if season.startDate.isGregorian {
                dateStr = date.string(withFormat: StartSeasonDateFormat)
            } else {
                dateStr = (date as Date).solarToLunar()
            }
            dateInfo = isNeedWeekDayInfo ? "\(dateStr) \(season.startDate.weakDay)" : dateStr
            
        case .week:
            if isLater == false {
                let count = date.distanceInDays(to: Date())
                date = date.addingDays(count + (7 - Int(count % 7))) as NSDate
            }
            
            let dateStr: String = date.string(withFormat: StartSeasonDateHMFormat)
            dateInfo = isNeedWeekDayInfo ? "\(dateStr) \((date as Date).weekDay())" : dateStr
            break
        case .workDay:
            if isLater == false {
                let count = date.distanceInDays(to: Date())
                date = date.addingDays(count + 1) as NSDate
            }
            let dateStr: String = date.string(withFormat: StartSeasonDateHMFormat)
            dateInfo = isNeedWeekDayInfo ? "\(dateStr) \((date as Date).weekDay())" : dateStr
            
        case .day:
            if isLater == false {
                let count = date.distanceInDays(to: Date())
                date = date.addingDays(count + 1) as NSDate
            }
            let dateStr: String = date.string(withFormat: StartSeasonDateHMFormat)
            dateInfo = isNeedWeekDayInfo ? "\(dateStr) \((date as Date).weekDay())" : dateStr
            
        default: // 默认
            
            var dateStr = ""
            if season.startDate.isGregorian {
                dateStr = season.startDate.gregoriandDataString
            } else {
                dateStr = season.startDate.lunarDataString
            }
            
            if isNeedWeekDayInfo {
                dateInfo = "\(dateStr) \(season.startDate.weakDay.isEmpty ? (date as Date).weekDay() : season.startDate.weakDay)"
            } else {
                dateInfo = dateStr
            }
        }
        
        isLater = date.isLaterThanDate(Date())
        timeIntervalString = (date as Date).convertToTimeAndUnitString(type: type)
        return (timeIntervalString, date, dateInfo, isLater)
    }
    
    /// 根据内容计算字体大小
    static func calculateFontSizeAndWidth(_ text: String, margin: CGFloat) -> (UIFont, CGFloat) {
        let actualSize = CGSize(width: IT_SCREEN_WIDTH, height: 50.0)
        var fontSize = 70
        var estimateWidth: CGFloat = 100.0
        for size in 30...70 {
            let font = UIFont(name: FontName, size: CGFloat(size)) ?? .boldSystemFont(ofSize: CGFloat(size))
            let estimateFrame = (text + " ").boundingRect(with: actualSize,
                                                          options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                          attributes: [NSAttributedString.Key.font: font],
                                                          context: nil)
            if estimateFrame.size.width - actualSize.width > -(margin * 2.0 + 10.0) {
                fontSize = size - 1
                break
            } else {
                estimateWidth = estimateFrame.size.width
            }
        }
        let font = UIFont(name: FontName, size: CGFloat(fontSize)) ?? .boldSystemFont(ofSize: CGFloat(fontSize))
        return (font, estimateWidth)
    }
}
