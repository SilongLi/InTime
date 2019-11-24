//
//  Date+Extensions.swift
//  InTime
//
//  Created by lisilong on 2019/11/23.
//  Copyright © 2019 BruceLi. All rights reserved.
//

import Foundation

private let componentFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfMonth, .weekday, .weekdayOrdinal])

private let D_MINUTE = 60
private let D_HOUR   = 3600
private let D_DAY    = 86400
private let D_WEEK   = 604800
private let D_YEAR   = 31556926

extension Date {
    
    static let currentCalendar = Calendar.current
    
    // MARK: - 根据数字获取时间
    static func dateWithDaysFromNow(_ days: NSInteger) -> Date? {
        return Date().addingDays(days)
    }
    
    static func dateWithDaysBeforeNow(_ days: NSInteger) -> Date? {
        return Date().subtractingDay(days)
    }
    
    static func dateTomorrow() -> Date? {
        return Date.dateWithDaysFromNow(1)
    }
    
    static func dateYesterday() -> Date? {
        return Date.dateWithDaysBeforeNow(1)
    }
    
    static func dateWithHoursFromNow(_ hours: NSInteger) -> Date? {
        let interval = self.timeIntervalSinceReferenceDate + Double(D_HOUR * hours)
        return Date.init(timeIntervalSinceReferenceDate: interval)
    }
    
    static func dateWithHoursBeforeNow(_ hours: NSInteger) -> Date? {
        let interval = self.timeIntervalSinceReferenceDate - Double(D_HOUR * hours)
        return Date.init(timeIntervalSinceReferenceDate: interval)
    }
    
    static func dateWithMinutesFromNow(_ minutes: NSInteger) -> Date? {
        let interval = self.timeIntervalSinceReferenceDate + Double(D_MINUTE * minutes)
        return Date.init(timeIntervalSinceReferenceDate: interval)
    }
    
    static func dateWithMinutesBeforeNow(_ minutes: NSInteger) -> Date? {
        let interval = self.timeIntervalSinceReferenceDate - Double(D_MINUTE * minutes)
        return Date.init(timeIntervalSinceReferenceDate: interval)
    }
     
    static func date(withDateString dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
     
    // MARK: - Date Formatter
    
    func string(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
 
    func string(withDateStyle dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: self)
    }

    func shortString() -> String {
        return self.string(withDateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
    }

    func shortTimeString() -> String {
        return self.string(withDateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
    }

    func shortDateString() -> String {
        return self.string(withDateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
    }

    func mediumString() -> String {
        return self.string(withDateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }

    func mediumTimeString() -> String {
        return self.string(withDateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
    }

    func mediumDateString() -> String {
        return self.string(withDateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    }

    func longString() -> String {
        return self.string(withDateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.long)
    }

    func longTimeString() -> String {
        return self.string(withDateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.long)
    }

    func longDateString() -> String {
        return self.string(withDateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
    }
    
    // MARK: - 时间比较
    
    func isEqualToDateIgnoringTime(_ date: Date) -> Bool {
        let components1 = Date.currentCalendar.dateComponents(componentFlags, from: self)
        let components2 = Date.currentCalendar.dateComponents(componentFlags, from: date)
        return ((components1.year == components2.year) &&
                (components1.month == components2.month) &&
                (components1.day == components2.day))
    }
 
    func isToday() -> Bool {
        return self.isEqualToDateIgnoringTime(Date())
    }

    func isMorning() -> Bool {
        var components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        components.hour = 11;
        components.minute = 59;
        components.second = 59;
        let lastMorningDate = Date.currentCalendar.date(from: components) ?? Date()
        return self.isEarlierThanDate(lastMorningDate)
    }
    
    func isTomorrow() -> Bool {
        return self.isEqualToDateIgnoringTime(Date.dateTomorrow() ?? Date())
    }
    
    func isYesterday() -> Bool {
        return self.isEqualToDateIgnoringTime(Date.dateYesterday() ?? Date())
    }
 
    func isSameWeekAsDate(_ date: Date) -> Bool {
        let components1 = Date.currentCalendar.dateComponents(componentFlags, from: self)
        let components2 = Date.currentCalendar.dateComponents(componentFlags, from: date)
        // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
        if (components1.weekOfMonth != components2.weekOfMonth) {
            return false
        }
        // Must have a time interval under 1 week.
        var interval = self.timeIntervalSince(date)
        interval = interval > 0 ? interval : -interval
        return Int(interval) < D_WEEK
    }

    func isThisWeek() -> Bool {
        return self.isSameWeekAsDate(Date())
    }

    func isNextWeek() -> Bool {
        let interval = Date().timeIntervalSinceReferenceDate + Double(D_WEEK)
        let newDate = Date.init(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(newDate)
    }

    func isLastWeek() -> Bool {
        let interval = Date().timeIntervalSinceReferenceDate - Double(D_WEEK)
        let newDate = Date.init(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(newDate)
    }
  
    func isSameMonthAsDate(_ date: Date) -> Bool {
        let components1 = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: self)
        let components2 = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: date)
        return ((components1.month == components2.month) && (components1.year == components2.year))
    }

    func isThisMonth() -> Bool {
        return self.isSameMonthAsDate(Date())
    }

    func isLastMonth() -> Bool {
        return self.isSameMonthAsDate(Date().subtractingMonth(1) ?? Date())
    }

    func isNextMonth() -> Bool {
        return self.isSameMonthAsDate(Date().addingMonth(1) ?? Date())
    }
 
    func isSameYearAsDate(_ date: Date) -> Bool {
        let components1 = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year]), from: self)
        let components2 = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year]), from: date)
        return components1.year == components2.year
    }

    func isThisYear() -> Bool {
        return self.isSameYearAsDate(Date())
    }

    func isNextYear() -> Bool {
        let components1 = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year]), from: self)
        let components2 = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year]), from: Date())
        return components1.year == (components2.year ?? 0 + 1)
    }

    func isEarlierThanDate(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedAscending
    }

    func isLaterThanDate(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedDescending
    }

    func isInFuture(_ date: Date) -> Bool {
        return self.isLaterThanDate(Date())
    }

    func isInPast(_ date: Date) -> Bool {
        return self.isEarlierThanDate(Date())
    }

    // MARK: - 是否为工作日或周末
    func isTypicallyWeekend() -> Bool {
        let components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.weekday]), from: self)
        if components.weekday == 1 || components.weekday == 7 {
            return true
        }
        return false
    }
  
    func isTypicallyWorkday() -> Bool {
        return !self.isTypicallyWeekend()
    }
    
    // MARK: - 扩展：获取当天的最早和最晚时间
    
    func dateAtStartOfDay() -> Date? {
        var components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Date.currentCalendar.date(from: components)
    }
    
    func dateAtEndOfDay() -> Date? {
        var components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return Date.currentCalendar.date(from: components)
    }

 
    // MARK: - 日期调整
    func addingYear(_ year: NSInteger) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        return Date.currentCalendar.date(byAdding: dateComponents, to: self) ?? self
    }
    
    func subtractingYear(_ year: NSInteger) -> Date {
        return self.addingYear(-year)
    }
 
    func addingMonth(_ month: NSInteger) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = month
        return Date.currentCalendar.date(byAdding: dateComponents, to: self) ?? self
    }
    
    func subtractingMonth(_ month: NSInteger) -> Date {
        return self.addingMonth(-month)
    }
    
    func componentsWithOffsetFromDate(_ date: Date) -> DateComponents {
        return Date.currentCalendar.dateComponents(componentFlags, from: date, to: self)
    }

    func addingDays(_ days: NSInteger) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Date.currentCalendar.date(byAdding: dateComponents, to: self) ?? self
    }
    
    func subtractingDay(_ days: NSInteger) -> Date {
        return self.addingDays(-days)
    }
    
    func addingHour(_ hours: NSInteger) -> Date {
        let interval = self.timeIntervalSinceReferenceDate + Double(D_HOUR * hours)
        return Date.init(timeIntervalSinceReferenceDate: interval)
    }
 
    func subtractingHour(_ hours: NSInteger) -> Date {
        return self.addingHour(-hours)
    }
    
    func addingMinute(_ minutes: NSInteger) -> Date {
        let interval = self.timeIntervalSinceReferenceDate + Double(D_MINUTE * minutes)
        return Date.init(timeIntervalSinceReferenceDate: interval)
    }

    func subtractingMinute(_ minutes: NSInteger) -> Date {
        return self.addingMinute(-minutes)
    }
    
    func subtractingMinute(_ date: Date) -> DateComponents? {
        return Date.currentCalendar.dateComponents(componentFlags, from: date, to: self)
    }
    
    // MARK: - 获取日期值
    
    func minutesAfterDate(_ date: Date) -> NSInteger {
        let interval = self.timeIntervalSince(date)
        return NSInteger(interval) / D_MINUTE
    }
    
    func minutesBeforeDate(_ date: Date) -> NSInteger {
        let interval = date.timeIntervalSince(self)
        return NSInteger(interval) / D_MINUTE
    }
    
    func hoursAfterDate(_ date: Date) -> NSInteger {
        let interval = self.timeIntervalSince(date)
        return NSInteger(interval) / D_HOUR
    }
    
    func hoursBeforeDate(_ date: Date) -> NSInteger {
        let interval = date.timeIntervalSince(self)
        return NSInteger(interval) / D_HOUR
    }
    
    func daysAfterDate(_ date: Date) -> NSInteger {
        let interval = self.timeIntervalSince(date)
        return NSInteger(interval) / D_DAY
    }
    
    func daysBeforeDate(_ date: Date) -> NSInteger {
        let interval = date.timeIntervalSince(self)
        return NSInteger(interval) / D_DAY
    }
  
    func distanceInDays(_ date: Date) -> NSInteger {
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let components = gregorianCalendar.dateComponents(Set<Calendar.Component>([.day]), from: self, to: date)
        return components.day ?? 0
    }
 
    // MARK: - 分解时间
    
    func nearestHour() -> NSInteger {
        let interval = Date().timeIntervalSinceReferenceDate + Double(D_MINUTE * 30)
        let newDate = Date.init(timeIntervalSinceReferenceDate: interval)
        let components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.hour]), from: newDate)
        return components.hour ?? 0
    }
 
    func hour() -> NSInteger {
        let components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        return components.hour ?? 0
    }

    func minute() -> NSInteger {
        let components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        return components.minute ?? 0
    }

    func second() -> NSInteger {
        let components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        return components.second ?? 0
    }

    func day() -> NSInteger {
        let components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        return components.day ?? 0
    }

    func month() -> NSInteger {
        let components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        return components.month ?? 0
    }

    func weekOfMonth() -> NSInteger {
        let components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        return components.weekOfMonth ?? 0
    }

    func weekday() -> NSInteger {
        let components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        return components.weekday ?? 0
    }

    /// e.g. 2nd Tuesday of the month is 2
    func weekdayOrdinal() -> NSInteger {
        let components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        return components.weekdayOrdinal ?? 0
    }

    func year() -> NSInteger {
        let components = Date.currentCalendar.dateComponents(componentFlags, from: self)
        return components.year ?? 0
    }
    
    func dateWithYMD() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selfDateString = dateFormatter.string(from: self)
        return dateFormatter.date(from: selfDateString)
    }
    
    func dateWithFormatter(_ dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let selfDateString = dateFormatter.string(from: self)
        return dateFormatter.date(from: selfDateString)
    }
    
    /// 公历转农历
    func solarToLunar(_ style: DateFormatter.Style) -> String {
        let solarCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.year     = self.year()
        components.month    = self.month()
        components.day      = self.day()
        components.hour     = 12
        components.minute   = 0
        components.second   = 0
        components.timeZone = TimeZone.init(secondsFromGMT: 60 * 60 * 8)
        let solarDate = solarCalendar.date(from: components)
        
        guard let date = solarDate else {
            return ""
        }
        let lunarCalendar = Calendar.init(identifier: Calendar.Identifier.chinese)
        let formatter = DateFormatter()
        formatter.locale    = Locale.init(identifier: "zh_CN")
        formatter.dateStyle = style
        formatter.calendar  = lunarCalendar
        return formatter.string(from: date)
    }

    /// 计算两个日期的时间差，秒
    func convert(toSecond date: Date) -> String {
        var components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.second]), from: date, to: self)
        if self.isEarlierThanDate(date) {
            components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.second]), from: self, to: date)
        }
        return "\(components.second ?? 0)"
    }
    
    /// 计算两个日期的时间差，分
    func convert(toMinute date: Date) -> String {
        var components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.second, .minute]), from: self, to: date)
        if self.isLaterThanDate(date) {
            components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.second, .minute]), from: date, to: self)
        }
        var minute = components.minute ?? 0
        if self.isLaterThanDate(date) {
            minute += components.second ?? 0 > 0 ? 1 : 0
        }
        return "\(minute)"
    }

    /// 计算两个日期的时间差，小时
    func convert(toHour date: Date) -> String {
        var components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.minute, .hour]), from: self, to: date)
        if self.isLaterThanDate(date) {
            components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.minute, .hour]), from: date, to: self)
        }
        var hour = components.hour ?? 0
        if self.isLaterThanDate(date) {
            hour += components.minute ?? 0 > 0 ? 1 : 0
        }
        return "\(hour)"
    }

    /// 计算两个日期的时间差，天
    func convert(toDay date: Date) -> String {
        var components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.day, .hour]), from: self, to: date)
        if self.isLaterThanDate(date) {
            components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.day, .hour]), from: date, to: self)
        }
        var day = components.day ?? 0
        if self.isLaterThanDate(date) {
            day += components.hour ?? 0 > 0 ? 1 : 0
        }
        return "\(day)"
    }

    /// 计算两个日期的时间差，周
    func convert(toWeek date: Date) -> String {
        var components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.day, .hour]), from: self, to: date)
        if self.isLaterThanDate(date) {
            components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.day, .hour]), from: date, to: self)
        }
        var totayDay = components.day ?? 0
        if self.isLaterThanDate(date) {
            totayDay += components.hour ?? 0 > 0 ? 1 : 0
        }
        let week = totayDay / 7
        let day = totayDay - week * 7
        
        var dateString = ""
        if week > 0 {
            dateString += "\(week)周"
        }
        if day > 0 {
            dateString += "\(day)天"
        }
        return dateString
    }

    /// 计算两个日期的时间差，年月天
    func convert(toYMD date: Date) -> String {
        var components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year, .month, .day]), from: date, to: self)
        if self.isEarlierThanDate(date) {
            components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year, .month, .day]), from: self, to: date)
        }
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        
        var dateString = ""
        if year > 0 {
            dateString += "\(year)年"
        }
        if month > 0 {
            dateString += "\(month)月"
        }
        if day > 0 {
            dateString += "\(day)天"
        }
        return dateString
    }
  
    /// 计算两个日期的时间差，天时分秒
    func convert(toDHMS date: Date) -> String {
        var components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.second, .minute, .hour, .day]), from: date, to: self)
        if self.isEarlierThanDate(date) {
            components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.second, .minute, .hour, .day]), from: self, to: date)
        }
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        var dateString = ""
        if day > 0 {
            dateString += "\(day)天"
        }
        if hour > 0 {
            dateString += "\(hour)时"
        }
        if minute > 0 {
            dateString += "\(minute)分"
        }
        dateString += "\(second)秒"
        return dateString
    }

    /// 计算两个日期的时间差，年月日时分秒
    func convert(toYMDHMS date: Date) -> String {
        var components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second]), from: date, to: self)
        if self.isEarlierThanDate(date) {
            components = Date.currentCalendar.dateComponents(Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second]), from: self, to: date)
        }
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        var dateString = ""
        if year > 0 {
            dateString += "\(year)年"
        }
        if month > 0 {
            dateString += "\(month)月"
        }
        if day > 0 {
            dateString += "\(day)天"
        }
        if hour > 0 {
            dateString += "\(hour)时"
        }
        if minute > 0 {
            dateString += "\(minute)分"
        }
        dateString += "\(second)秒"
        return dateString
    }
 
}

 

