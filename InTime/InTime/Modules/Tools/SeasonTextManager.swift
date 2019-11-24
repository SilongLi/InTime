//
//  SeasonTextManager.swift
//  InTime
//
//  Created by lisilong on 2019/2/25.
//  Copyright © 2019 BruceLi. All rights reserved.
//
// 时节视图文案处理

import Foundation
import UIKit
import CoreGraphics

class SeasonTextManager {

    static func handleSeasonInfo(_ season: SeasonModel, isNeedWeekDayInfo: Bool = true, _ currentDate: Date = Date()) -> (String, date: Date, dateInfo: String, isLater: Bool) {
        var timeIntervalString = ""
        var dateInfo = ""
        // 闹铃日期是否在当前时间之后
        var isLater = true
         
        guard var date = Date.date(withDateString: season.startDate.gregoriandDataString, dateFormat: StartSeasonDateFormat) else {
            return (timeIntervalString, currentDate, dateInfo, isLater)
        }
        // 倒计时显示类型
        let type: DateUnitType = DateUnitType(rawValue: season.unitModel.info) ?? DateUnitType.dayTime
        isLater = date.isLaterThanDate(currentDate)
        
        switch season.repeatRemindType {
        case .year:
            if isLater == false {
                var yearCount = currentDate.year() - date.year()
                if (currentDate.month() > date.month()) ||
                    (currentDate.month() == date.month() && currentDate.day() > date.day()) {
                    yearCount += 1
                }
                date = date.addingYear(yearCount)
            }
            
            var dateStr = ""
            if season.startDate.isGregorian {
                dateStr = date.string(withFormat: StartSeasonDateFormat)
            } else {
                dateStr = date.solarToLunar()
            }
            dateInfo = isNeedWeekDayInfo ? "\(dateStr) \(season.startDate.weakDay)" : dateStr
            
        case .month:
            if isLater == false {
                var yearCount = currentDate.year() - date.year()
                let isNeedAdd = (date.month() == currentDate.month() && currentDate.month() == 12 && currentDate.day() > date.day())
                if date.month() > currentDate.month() || isNeedAdd {
                    yearCount += 1
                }
                date = date.addingYear(yearCount)
                
                var monthCount = currentDate.month() - date.month()
                if currentDate.day() > date.day() {
                    monthCount = monthCount + 1
                }
                date = date.addingMonth(monthCount)
            }
            
            var dateStr = ""
            if season.startDate.isGregorian {
                dateStr = date.string(withFormat: StartSeasonDateFormat)
            } else {
                dateStr = date.solarToLunar()
            }
            dateInfo = isNeedWeekDayInfo ? "\(dateStr) \(season.startDate.weakDay)" : dateStr
            
        case .week:
            if isLater == false {
                let count = date.distanceInDays(currentDate)
                date = date.addingDays(count + (7 - Int(count % 7)))
            }
            
            let dateStr: String = date.string(withFormat: StartSeasonDateHMFormat)
            dateInfo = isNeedWeekDayInfo ? "\(dateStr) \(date.weekDay())" : dateStr
            break
        case .workDay:
            if isLater == false {
                let count = date.distanceInDays(currentDate)
                date = date.addingDays(count + 1)
            }
            let dateStr: String = date.string(withFormat: StartSeasonDateHMFormat)
            dateInfo = isNeedWeekDayInfo ? "\(dateStr) \(date.weekDay())" : dateStr
            
        case .day:
            if isLater == false {
                let count = date.distanceInDays(currentDate)
                date = date.addingDays(count + 1)
            }
            let dateStr: String = date.string(withFormat: StartSeasonDateHMFormat)
            dateInfo = isNeedWeekDayInfo ? "\(dateStr) \(date.weekDay())" : dateStr
            
        default: // 默认
            var dateStr = ""
            if season.startDate.isGregorian {
                dateStr = season.startDate.gregoriandDataString
            } else {
                dateStr = season.startDate.lunarDataString
            }
            
            if isNeedWeekDayInfo {
                dateInfo = "\(dateStr) \(season.startDate.weakDay.isEmpty ? date.weekDay() : season.startDate.weakDay)"
            } else {
                dateInfo = dateStr
            }
        }
        
        isLater = date.isLaterThanDate(currentDate)
        timeIntervalString = date.convertToTimeAndUnitString(type: type, currentDate)
        return (timeIntervalString, date, dateInfo, isLater)
    }
    
    /// 根据内容计算字体大小
    static func calculateFontSizeAndWidth(_ text: String, margin: CGFloat) -> (UIFont, CGFloat) {
        let screenWidth = UIScreen.main.bounds.size.width
        let actualSize = CGSize(width: screenWidth, height: 50.0)
        var estimateWidth: CGFloat = 100.0
        
        var textValue = text
        var estimateMargin: CGFloat = margin * 2.0 + 10.0
        var sizeArray = 20...60
        if text.count < 5 {
            sizeArray = 60...80
            textValue = text
            estimateMargin = margin * 2.0
        }
        var fontSize  = sizeArray.first ?? 20
        
        for size in sizeArray {
            let font = UIFont(name: FontName, size: CGFloat(size)) ?? .boldSystemFont(ofSize: CGFloat(size))
            let estimateFrame = textValue.boundingRect(with: actualSize,
                                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                       attributes: [NSAttributedString.Key.font: font],
                                                       context: nil)
            if estimateFrame.size.width - actualSize.width > -estimateMargin {
                break
            } else {
                fontSize = size
                estimateWidth = estimateFrame.size.width
            }
        }
        let font = UIFont(name: FontName, size: CGFloat(fontSize)) ?? .boldSystemFont(ofSize: CGFloat(fontSize))
        return (font, estimateWidth)
    }
}
