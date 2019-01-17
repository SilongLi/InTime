//
//  Date+ToLuarCalendar.swift
//  InTime
//
//  Created by lisilong on 2019/1/17.
//  Copyright © 2019 BruceLi. All rights reserved.
//


extension Date {
    
    /// 公历转农历
    func solarToLunar(style: DateFormatter.Style = .long) -> String? {
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
            return nil
        }
        let lunarCalendar   = Calendar.init(identifier: .chinese)
        let formatter       = DateFormatter()
        formatter.locale    = Locale(identifier: "zh_CN")
        formatter.dateStyle = style
        formatter.calendar  = lunarCalendar
        return formatter.string(from: solarDate)
    }
}
