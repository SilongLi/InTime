//
//  Date+ToLuarCalendar.swift
//  InTime
//
//  Created by lisilong on 2019/1/17.
//  Copyright © 2019 BruceLi. All rights reserved.
//


extension Date {
    
    /// 公历转农历
    func solarToLunar(style: DateFormatter.Style = .long) -> String {
        let solarCalendar   = Calendar(identifier: .gregorian)
        var components      = DateComponents()
        components.year     = (self as NSDate).year
        components.month    = (self as NSDate).month
        components.day      = (self as NSDate).day
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
        let timeStr: String = (self as NSDate).string(withFormat: "HH:mm")
        return "\(solarDateStr) \(timeStr)"
    }
    
    /// 获取当天是星期几
    func weekDay() -> String {
        let weekDays = [NSNull(), "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"] as [Any]
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        if let timeZone = NSTimeZone(name:"Asia/Shanghai") {
            calendar?.timeZone = timeZone as TimeZone
        }
        let theComponents = calendar?.components(NSCalendar.Unit.weekday, from: self)
        if let index = theComponents?.weekday, index != 0 {
            return weekDays[index] as! String
        }
        return ""
    }
    
    /// 倒计时
    func convertToTimeString(type: DateUnitType = DateUnitType.dayTime) -> String {
        switch type {
        case .second:
            return convertToSeconds()
        case .minute:
            return convertToMinutes()
        case .hour:
            return convertToHours()
        case .day:
            return convertToDays()
        case .dayTime:
            return convertToDayTime()
        case .year:
            return convertToYear()
        case .percentage:
            return convertToPercentage()
        }
    }
    
    private func convertToSeconds() -> String {
        let intervals = Int(self.timeIntervalSinceNow)
        return "\(intervals)".it.stringSeparateByCommaInteger()
    }
    
    private func convertToMinutes() -> String {
        let intervals = Int(self.timeIntervalSinceNow)
        var minutes = intervals / 60
        minutes += (intervals - minutes * 60) > 0 ? 1 : 0
        return "\(minutes)".it.stringSeparateByCommaInteger()
    }
    
    private func convertToHours() -> String {
        let intervals = Int(self.timeIntervalSinceNow)
        var hours = intervals / 60 / 60
        hours += (intervals - hours * 60 * 60) > 0 ? 1 : 0
        return "\(hours)".it.stringSeparateByCommaInteger()
    }
    
    private func convertToDays() -> String {
        let intervals = Int(self.timeIntervalSinceNow)
        var day = intervals / 60 / 60 / 24
        day += (intervals - day * 60 * 60 * 24) > 0 ? 1 : 0
        return "\(day)".it.stringSeparateByCommaInteger()
    }
    
    private func convertToDayTime() -> String {
        let intervals = Int(self.timeIntervalSinceNow)
        let currentDate = Date()
        let years = (self as NSDate).year - (currentDate as NSDate).year
        let days = intervals / 60 / 60 / 24
        let hours = intervals / 60 / 60 - (days * 24)
        let minutes = intervals / 60 - (days * 24 * 60 + hours * 60)
        let seconds = intervals - (days * 24 * 60 * 60 + hours * 60 * 60 + minutes * 60)
        var dateText = ""
        if years != 0 {
            dateText += "\(years)年"
        }
        if days != 0 {
            dateText += "\(days)天"
        }
        if hours != 0 {
            dateText += "\(hours)时"
        }
        if minutes != 0 {
            dateText += "\(minutes)分"
        }
        if seconds != 0 {
            dateText += "\(seconds)秒"
        }
        return dateText
    }
    
    private func convertToYear() -> String {
        let currentDate = Date()
        var years = (self as NSDate).year - (currentDate as NSDate).year
        var month = (self as NSDate).month - (currentDate as NSDate).month
        var days  = (self as NSDate).day - (currentDate as NSDate).day
        if (self as NSDate).isEarlierThanDate(currentDate) {
            years = (currentDate as NSDate).year - (self as NSDate).year
            month = (currentDate as NSDate).month - (self as NSDate).month
            days  = (currentDate as NSDate).day - (self as NSDate).day
        }
        var dateText = ""
        if years != 0 {
            dateText += "\(years)年"
        }
        if month != 0 {
            dateText += "\(month)月"
        }
        if days != 0 {
            dateText += "\(days)天"
        }
        return dateText
    }
    
    private func convertToPercentage() -> String {
        return "49.999"
    }
}
