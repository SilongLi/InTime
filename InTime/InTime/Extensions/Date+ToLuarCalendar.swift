//
//  Date+ToLuarCalendar.swift
//  InTime
//
//  Created by lisilong on 2019/1/17.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import UIKit

let SeasonDateFormat: String = "yyyy.MM.dd HH:mm:ss"

extension Date {
    
    /// 公历转农历
    func solarToLunar(style: DateFormatter.Style = .long) -> String {
        let solarCalendar   = Calendar(identifier: .gregorian)
        var components      = DateComponents()
        components.year     = self.year()
        components.month    = self.month()
        components.day      = self.day()
        components.hour     = 12
        components.minute   = 0
        components.second   = 0
        components.timeZone = TimeZone.init(secondsFromGMT: 60 * 60 * 8)
        
        guard let solarDate = solarCalendar.date(from: components) else {
            return ""
        }
        let lunarCalendar   = Calendar.init(identifier: .chinese)
        let formatter       = DateFormatter()
        formatter.locale    = Locale(identifier: "zh_CN")
        formatter.dateStyle = style
        formatter.calendar  = lunarCalendar
        
        let solarDateStr = formatter.string(from: solarDate)
        let timeStr: String = self.string(withFormat: "HH:mm")
        return "\(solarDateStr) \(timeStr)"
    }
     
    /// 公历转农历，只有年月日
    func solarToLunarOnlyYMD(style: DateFormatter.Style = .long) -> String {
        let solarCalendar   = Calendar(identifier: .gregorian)
        var components      = DateComponents()
        components.year     = self.year()
        components.month    = self.month()
        components.day      = self.day()
        components.hour     = 0
        components.minute   = 0
        components.second   = 0
        components.timeZone = TimeZone.init(secondsFromGMT: 60 * 60 * 8)
        
        guard let solarDate = solarCalendar.date(from: components) else {
            return ""
        }
        let lunarCalendar   = Calendar.init(identifier: .chinese)
        let formatter       = DateFormatter()
        formatter.locale    = Locale(identifier: "zh_CN")
        formatter.dateStyle = style
        formatter.calendar  = lunarCalendar
        
        let solarDateStr = formatter.string(from: solarDate)
        return solarDateStr
    }
    
    func zero() -> Date {
        let calendar   = Calendar(identifier: .chinese)
        var components      = DateComponents()
        components.year     = self.year()
        components.month    = self.month()
        components.day      = self.day()
        components.hour     = 0
        components.minute   = 0
        components.second   = 0
        guard let date = calendar.date(from: components) else {
            return self
        }
        return date
    }
    
    func maxDate() -> Date {
        let calendar   = Calendar(identifier: .chinese)
        var components      = DateComponents()
        components.year     = self.year()
        components.month    = self.month()
        components.day      = self.day()
        components.hour     = 23
        components.minute   = 59
        components.second   = 59
        guard let date = calendar.date(from: components) else {
            return self
        }
        return date
    }
    
    /// 获取当天是星期几
    func weekDay() -> String {
        let weekDays = [NSNull(), "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"] as [Any]
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        calendar?.timeZone = TimeZone(identifier: "Asia/Beijing") ?? TimeZone.current
        let theComponents = calendar?.components(NSCalendar.Unit.weekday, from: self)
        if let index = theComponents?.weekday, index != 0 {
            return weekDays[index] as! String
        }
        return ""
    }
    
    /// 计算时间差
    func convertToTimeAndUnitString(type: DateUnitType = DateUnitType.dayTime, _ date: Date = Date()) -> String {
        switch type {
        case .second:
            let dateStr = self.convert(toSecond: date).it.stringSeparateByCommaInteger()
            return "\(dateStr)"
        case .minute:
            let dateStr = self.convert(toMinute: date).it.stringSeparateByCommaInteger()
            return "\(dateStr)"
        case .hour:
            let dateStr = self.convert(toHour: date).it.stringSeparateByCommaInteger()
            return "\(dateStr)"
        case .day:
            let dateStr = self.convert(toDay: date).it.stringSeparateByCommaInteger()
            return "\(dateStr)"
        case .weak:
            let dateStr = self.convert(toWeek: date)
            return dateStr.isEmpty ? "今天" : dateStr
        case .dayTime:
            return self.convert(toDHMS: date)
        case .year:
            let dateStr = self.convert(toYMD: date) 
            return dateStr.isEmpty ? "今天" : dateStr
        case .yearTime:
            return self.convert(toYMDHMS: date)
        case .percentage:
            return convertToPercentage()
        }
    }
    
    private func convertToPercentage() -> String {
        return "49.999"
    }
}
