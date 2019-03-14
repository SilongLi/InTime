//
//  Date+ToLuarCalendar.swift
//  InTime
//
//  Created by lisilong on 2019/1/17.
//  Copyright © 2019 BruceLi. All rights reserved.
//


let SeasonDateFormat: String = "yyyy.MM.dd HH:mm:ss"

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
        calendar?.timeZone = TimeZone(identifier: "Asia/Beijing") ?? TimeZone.current
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
            return (self as NSDate).convertToSecond().it.stringSeparateByCommaInteger()
        case .minute:
            return (self as NSDate).convertToMinute().it.stringSeparateByCommaInteger()
        case .hour:
            return (self as NSDate).convertToHour().it.stringSeparateByCommaInteger()
        case .day:
            return (self as NSDate).convertToDay().it.stringSeparateByCommaInteger()
        case .dayTime:
            return (self as NSDate).convertToDHMS()
        case .year:
            return (self as NSDate).convertToYMD()
        case .yearTime:
            return (self as NSDate).convertToYMDHMS()
        case .percentage:
            return convertToPercentage()
        }
    }
    
    func convertToTimeAndUnitString(type: DateUnitType = DateUnitType.dayTime) -> String {
        switch type {
        case .second:
            let dateStr = (self as NSDate).convertToSecond().it.stringSeparateByCommaInteger()
            return "\(dateStr)秒"
        case .minute:
            let dateStr = (self as NSDate).convertToMinute().it.stringSeparateByCommaInteger()
            return "\(dateStr)分"
        case .hour:
            let dateStr = (self as NSDate).convertToHour().it.stringSeparateByCommaInteger()
            return "\(dateStr)时"
        case .day:
            let dateStr = (self as NSDate).convertToDay().it.stringSeparateByCommaInteger()
            return "\(dateStr)天"
        case .dayTime:
            return (self as NSDate).convertToDHMS()
        case .year:
            let dateStr = (self as NSDate).convertToYMD() ?? ""
            return dateStr.isEmpty ? "0天" : dateStr
        case .yearTime:
            return (self as NSDate).convertToYMDHMS()
        case .percentage:
            return convertToPercentage()
        }
    }
    
    private func convertToPercentage() -> String {
        return "49.999"
    }
}
