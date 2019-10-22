//
//  NSDate+Extension.m
//  SmartLock
//
//  Created by 江欣华 on 2016/10/25.
//  Copyright © 2016年 工程锁. All rights reserved.
//

#import "NSDate+Extension.h"

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (Extension)
// Courtesy of Lukasz Margielewski
// Updated via Holger Haenisch
+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

#pragma mark - Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark - String Properties
- (NSString *) stringWithFormat: (NSString *) format
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    return [formatter stringFromDate:self];
}

- (NSString *) shortString
{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) shortTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) shortDateString
{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) mediumString
{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) mediumTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) mediumDateString
{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) longString
{
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) longTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) longDateString
{
    return [self stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}

#pragma mark - Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isMorning
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 11;
    components.minute = 59;
    components.second = 59;
    NSDate *lastMorningDate = [[NSDate currentCalendar] dateFromComponents:components];
    return [self isEarlierThanDate:lastMorningDate];
}

- (BOOL) isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfMonth != components2.weekOfMonth) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

// Thanks Marcin Krzyzanowski, also for adding/subtracting years and months
- (BOOL) isLastMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}

- (BOOL) isNextMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark - Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark - Adjusting Dates

// Thaks, rsjohnson
- (NSDate *) dateByAddingYears: (NSInteger) dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingYears: (NSInteger) dYears
{
    return [self dateByAddingYears:-dYears];
}

- (NSDate *) dateByAddingMonths: (NSInteger) dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths
{
    return [self dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark - Extremes

- (NSDate *) dateAtStartOfDay
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

// Thanks gsempe & mteece
- (NSDate *) dateAtEndOfDay
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

#pragma mark - Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark - Decomposing Dates

- (NSInteger) nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger) hour
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

- (NSInteger) minute
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

- (NSInteger) seconds
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

- (NSInteger) day
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

- (NSInteger) month
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger) week
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger) weekday
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger) year
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}

+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:datestr];
#if ! __has_feature(objc_arc)
    [dateFormatter release];
#endif
    return date;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

-(NSDate *)dateWithFormatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = formatter;
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/// 公历转农历
- (NSString *)solarToLunar:(NSDateFormatterStyle)style {
    NSCalendar *solarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year     = self.year;
    components.month    = self.month;
    components.day      = self.day;
    components.hour     = 12;
    components.minute   = 0;
    components.second   = 0;
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:60 * 60 * 8];
    NSDate *solarDate   = [solarCalendar dateFromComponents:components];
    
    NSCalendar *lunarCalendar  = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale    = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateStyle = style;
    formatter.calendar  = lunarCalendar;
    return [formatter stringFromDate:solarDate];
}

/// 计算两个日期的时间差，秒
- (NSString *)convertToSecond:(NSDate *)date {
    NSCalendarUnit unit = NSCalendarUnitSecond;
    NSDateComponents *components;
    if ([self isEarlierThanDate:date]) {
        components = [[NSDate currentCalendar] components:unit fromDate:self toDate:date options:0];
    } else {
        components = [[NSDate currentCalendar] components:unit fromDate:date toDate:self options:0];
    }
    NSInteger second = components.second;
    return [NSString stringWithFormat:@"%zd", second];
}

/// 计算两个日期的时间差，分
- (NSString *)convertToMinute:(NSDate *)date {
    NSCalendarUnit unit = NSCalendarUnitSecond | NSCalendarUnitMinute;
    NSDateComponents *components;
    BOOL isLater = [self isLaterThanDate:date];
    if (isLater) {
        components = [[NSDate currentCalendar] components:unit fromDate:date toDate:self options:0];
    } else {
        components = [[NSDate currentCalendar] components:unit fromDate:self toDate:date options:0];
    }
    NSInteger minute = components.minute;
    if (isLater) {
        minute += components.second > 0 ? 1 : 0;
    }
    return [NSString stringWithFormat:@"%zd", minute];
}

/// 计算两个日期的时间差，小时
- (NSString *)convertToHour:(NSDate *)date {
    NSCalendarUnit unit = NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents *components;
    BOOL isLater = [self isLaterThanDate:date];
    if (isLater) {
        components = [[NSDate currentCalendar] components:unit fromDate:date toDate:self options:0];
    } else {
        components = [[NSDate currentCalendar] components:unit fromDate:self toDate:date options:0];
    }
    NSInteger hour = components.hour;
    if (isLater) {
        hour += components.minute > 0 ? 1 : 0;
    }
    return [NSString stringWithFormat:@"%zd", hour];
}

/// 计算两个日期的时间差，天
- (NSString *)convertToDay:(NSDate *)date {
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitDay;
    NSDateComponents *components;
    BOOL isLater = [self isLaterThanDate:date];
    if (isLater) {
        components = [[NSDate currentCalendar] components:unit fromDate:date toDate:self options:0];
    } else {
        components = [[NSDate currentCalendar] components:unit fromDate:self toDate:date options:0];
    }
    NSInteger day = components.day;
    if (isLater) {
        day += components.hour > 0 ? 1 : 0;
    }
    return [NSString stringWithFormat:@"%zd", day];
}


/// 计算两个日期的时间差，周
- (NSString *)convertToWeek:(NSDate *)date {
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitDay;
    NSDateComponents *components;
    BOOL isLater = [self isLaterThanDate:date];
    if (isLater) {
        components = [[NSDate currentCalendar] components:unit fromDate:date toDate:self options:0];
    } else {
        components = [[NSDate currentCalendar] components:unit fromDate:self toDate:date options:0];
    }
    NSInteger totayDay = components.day;
    if (isLater) {
        totayDay += components.hour > 0 ? 1 : 0;
    }
    NSInteger weak = totayDay / 7;
    NSInteger day = totayDay - weak * 7;
    
    NSMutableString *dateStr = [[NSMutableString alloc] init];
    if (weak > 0) {
        [dateStr appendFormat:@"%zd周", weak];
    }
    if (day > 0) {
        [dateStr appendFormat:@"%zd天", day];
    }
    return dateStr;
}

/// 计算两个日期的时间差，年月日
- (NSString *)convertToYMD:(NSDate *)date {
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *components;
    if ([self isEarlierThanDate:date]) {
        components = [[NSDate currentCalendar] components:unit fromDate:self toDate:date options:0];
    } else {
        components = [[NSDate currentCalendar] components:unit fromDate:date toDate:self options:0];
    }
    NSInteger year   = components.year;
    NSInteger month  = components.month;
    NSInteger day    = components.day;
    
    NSMutableString *dateStr = [[NSMutableString alloc] init];
    if (year > 0) {
        [dateStr appendFormat:@"%zd年", year];
    }
    if (month > 0) {
        [dateStr appendFormat:@"%zd月", month];
    }
    if (day > 0) {
        [dateStr appendFormat:@"%zd天", day];
    }
    return dateStr;
}

/// 计算两个日期的时间差，天时分秒
- (NSString *)convertToDHMS:(NSDate *)date {
    NSCalendarUnit unit = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay;
    NSDateComponents *components;
    if ([self isEarlierThanDate:date]) {
        components = [[NSDate currentCalendar] components:unit fromDate:self toDate:date options:0];
    } else {
        components = [[NSDate currentCalendar] components:unit fromDate:date toDate:self options:0];
    }
    NSInteger day    = components.day;
    NSInteger hour   = components.hour;
    NSInteger minute = components.minute;
    NSInteger second = components.second;
    
    NSMutableString *dateStr = [[NSMutableString alloc] init];
    if (day != 0) {
        [dateStr appendFormat:@"%zd天", day];
    }
    if (hour != 0) {
        [dateStr appendFormat:@"%zd时", hour];
    }
    if (minute != 0) {
        [dateStr appendFormat:@"%zd分", minute];
    }
    [dateStr appendFormat:@"%zd秒", second];
    return dateStr;
}

/// 计算两个日期的时间差，年月日时分秒
- (NSString *)convertToYMDHMS:(NSDate *)date {
    NSCalendarUnit unit = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *components;
    if ([self isEarlierThanDate:date]) {
        components = [[NSDate currentCalendar] components:unit fromDate:self toDate:date options:0];
    } else {
        components = [[NSDate currentCalendar] components:unit fromDate:date toDate:self options:0];
    }
    NSInteger year   = components.year;
    NSInteger month  = components.month;
    NSInteger day    = components.day;
    NSInteger hour   = components.hour;
    NSInteger minute = components.minute;
    NSInteger second = components.second;
    
    NSMutableString *dateStr = [[NSMutableString alloc] init];
    if (year != 0) {
        [dateStr appendFormat:@"%zd年", year];
    }
    if (month != 0) {
        [dateStr appendFormat:@"%zd月", month];
    }
    if (day != 0) {
        [dateStr appendFormat:@"%zd天", day];
    }
    if (hour != 0) {
        [dateStr appendFormat:@"%zd时", hour];
    }
    if (minute != 0) {
        [dateStr appendFormat:@"%zd分", minute];
    }
    [dateStr appendFormat:@"%zd秒", second];
    return dateStr;
}

#pragma mark - 获取当天的农历

+ (NSDate *)newYear {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:[NSDate date]];
    components.month = 1;
    components.day = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *date = [[NSDate currentCalendar] dateFromComponents:components];
    return date;
}

//- (NSString *)chineseCalendarOfDate:(NSDate *)date {
//    NSCalendar *chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
//    NSDateComponents *components = [chineseCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
//    NSCalendar *normalDate = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *Datecomponents = [normalDate components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
//
//    NSString *festival = @"";
//    if (components.day == 1 && components.month == 1) {
//        festival = @"春节";
//    } else if (components.month == 5 && components.day == 1) {
//        festival = @"元宵节";
//    } else if (components.month == 5 && components.day == 1) {
//        festival = @"劳动节";
//    } else if (components.month == 5 && components.day == 5) {
//        festival = @"端午";
//    } else if () {
//
//    } else if () {
//
//    } else if () {
//
//    }
//
//
//    if () {
//
//     } else if () {
//
//     } else if () {
//
//     } else if (components.month == 7 && components.day == 7) {
//         festival = @"七夕";
//     } else if (components.month == 8 && components.day == 15) {
//         festival = @"中秋";
//     }
//
//
//    if (Datecomponents.month == 1 && Datecomponents.day == 1) {
//        festival = @"过新年";
//    } else if (Datecomponents.month == 6 && Datecomponents.day == 1) {
//           festival = @"儿童节";
//   } else if (Datecomponents.month == 6 && Datecomponents.day == 1) {
//        festival = @"儿童节";
//    } else if (Datecomponents.month == 10 && Datecomponents.day == 1) {
//        festival = @"国庆节";
//    } else if (Datecomponents.month == 5 && Datecomponents.day == 1) {
//        festival = @"劳动节";
//    } else if (Datecomponents.month == 12 && Datecomponents.day == 25) {
//        festival = @"圣诞节";
//    }
//
//
//
//    //除夕 另外提出放在所有节日的末尾执行，除夕是在春节前一天，即把components当天时间前移一天，放在所有节日末尾，避免其他节日全部前移一天
//    NSTimeInterval timeInterval_day = 60 * 60 * 24;
//    NSDate *nextDay_date = [NSDate dateWithTimeInterval:timeInterval_day sinceDate:date];
//    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit;
//    components = [localeCalendar components:unitFlags fromDate:nextDay_date];
//    if ( 1 == components.month && 1 == components.day ) {
//        return @"除夕";
//    }
//    return festival;
//}

@end

