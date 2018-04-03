//
//  NSDate_Omesoft.m
//  
//
//  Created by sincan on 11-8-2.
//  Copyright 2011年 Omesoft. All rights reserved.
//
//dateformate yyyy-MM-dd hh.mm.ss.SSS

#import "NSDate_Omesoft.h"
#import "NSString+Omesoft.h"

@implementation NSDate (omesoft)

- (NSInteger)daysBetweenDate:(NSDate*)date{
	
	NSTimeInterval time = [self timeIntervalSinceDate:date];
	return fabs(time / 60 / 60/ 24);
}

- (NSInteger)pnDaysBetweenDate:(NSDate*)date{   // 有正负号
    
    NSTimeInterval time = [self timeIntervalSinceDate:date];
    return time / 60 / 60/ 24;
}

- (NSInteger)daysInDateInfo:(OMDateInformation)info
{
    OMDateInformation sinfo;
    sinfo.year = info.year;
    sinfo.month = info.month;
    sinfo.day = 1;
    sinfo.minute = 0;
    sinfo.second = 0;
    sinfo.hour = 0;
    sinfo.weekday = info.weekday;
    
    OMDateInformation einfo;
    int months = info.month + 1;
    einfo.month = months % 12;
    einfo.year = (int)(months / 12) ? info.year+1 : info.year;
    einfo.day = 1;
    einfo.second = 0;
    einfo.minute = 0;
    einfo.hour = 0;
    einfo.weekday = info.weekday;
    NSDate *sDate =  [NSDate dateFromOMDateInformation:sinfo timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *eDate = [NSDate dateFromOMDateInformation:einfo timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return [sDate daysBetweenDate:eDate];
}

- (NSInteger)yearBetweenDate:(NSDate *)date
{
    OMDateInformation fInfo = [self dateInformation];
    OMDateInformation sinfo = [date dateInformation];
    return abs(fInfo.year - sinfo.year);
}

- (NSInteger)birthdayAge
{
    OMDateInformation briInfo = [self dateInformation];
    OMDateInformation nowinfo = [[NSDate date] dateInformation];
    if (briInfo.year >= nowinfo.year) {
        return 0;
    } else {
        int yearValue = nowinfo.year - briInfo.year - 1;
        int monthValue = nowinfo.month + (12 - briInfo.month);
        if (monthValue % 12 == 0) {
            if (briInfo.day > nowinfo.day) {
                monthValue = 0;
            }
        }
        return (yearValue + (int)(monthValue / 12));
    }
}


- (NSString *)ageDetailInfo
{
    OMDateInformation briInfo = [self dateInformation];
    OMDateInformation nowinfo = [[NSDate date] dateInformation];
    int years = 0,months = 0,days = 0;
    if (briInfo.year <= nowinfo.year) {
        
        int yearValue = nowinfo.year - briInfo.year - 1;
        int daysIndex = 1;
        if (briInfo.day <= nowinfo.day) {
            daysIndex = 0;
            days = nowinfo.day - briInfo.day;
        } else {
            NSDate *firstOfdayDate;
            firstOfdayDate = [self startOfMonthWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            int dayInDate = (int)[firstOfdayDate daysBetweenDate:[firstOfdayDate nextMonth]];
            days = (dayInDate - briInfo.day + 1) + nowinfo.day;
        }
        
        int monthValue;
        if (briInfo.year == nowinfo.year) {
            monthValue = nowinfo.month - briInfo.month - daysIndex;
        } else {
            monthValue = nowinfo.month + (12 - briInfo.month) - 1 * daysIndex;
            years =  (yearValue + (int)(monthValue / 12));
        }
        
        months = monthValue % 12;
    }
    return [NSString stringWithFormat:@"%dY %dM %dD",years,months,days];
}


- (NSInteger)monthBetweenDate:(NSDate *)date
{
    OMDateInformation fInfo = [self dateInformation];
    OMDateInformation sInfo = [date dateInformation];
    int fmonthNum = 0;
    int smonthNum = 0;
    int index = 0;
    if (fInfo.year < sInfo.year) {
        index = sInfo.year - fInfo.year;
        smonthNum = index * 12 + sInfo.month;
        fmonthNum = fInfo.month;
    }else{
        index = fInfo.year - sInfo.year;
        fmonthNum = index * 12 + fInfo.month;
        smonthNum = sInfo.month;
    }
    return abs(smonthNum - fmonthNum);
}

- (NSInteger)monthForTodayBetweenDate:(NSDate *)date
{
    OMDateInformation fInfo = [self dateInformation];
    OMDateInformation sInfo = [date dateInformation];
    if (fInfo.day < sInfo.day) {
        return abs(fInfo.month - sInfo.month);
    }else{
        return abs(fInfo.month - sInfo.month+1);
    }
}

- (NSUInteger)year
{
    OMDateInformation info = [self dateInformation];
    return info.year;
}

- (NSUInteger)month
{
    OMDateInformation info = [self dateInformation];
    return info.month;
}

- (NSUInteger)day
{
    OMDateInformation info = [self dateInformation];
    return info.day;
}

- (NSUInteger)hour
{
    OMDateInformation info = [self dateInformation];
    return info.hour;
}

- (NSUInteger)minute
{
    OMDateInformation info = [self dateInformation];
    return info.minute;
}

- (OMDateInformation)dateInformationWithTimeZone:(NSTimeZone*)tz
{
	OMDateInformation info;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setTimeZone:tz];
    
    NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
													NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
										  fromDate:self];
	info.day = (int)[comp day];
	info.month = (int)[comp month];
	info.year = (int)[comp year];
	info.hour = (int)[comp hour];
	info.minute = (int)[comp minute];
	info.second = (int)[comp second];
	info.weekday = (int)[comp weekday];
#if ! __has_feature(objc_arc)
    [gregorian release];
#endif
	return info;
}

- (OMDateInformation)dateInformation
{
	OMDateInformation info;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
	NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
													NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
										  fromDate:self];
	info.day = (int)[comp day];
	info.month = (int)[comp month];
	info.year = (int)[comp year];
	info.hour = (int)[comp hour];
	info.minute = (int)[comp minute];
	info.second = (int)[comp second];
	info.weekday = (int)[comp weekday];
#if ! __has_feature(objc_arc)
    [gregorian release];
#endif
	
	return info;
}


+ (NSDate*)dateFromOMDateInformation:(OMDateInformation)info timeZone:(NSTimeZone*)tz{
	
    NSCalendar *gregorian;
#if  __has_feature(objc_arc)
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#else
    gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
#endif

	[gregorian setTimeZone:tz];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
	[comp setTimeZone:tz];
	return [gregorian dateFromComponents:comp];
}


- (NSDate*)UTCDate
{
    OMDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone systemTimeZone]];
	return [NSDate dateFromOMDateInformation:info timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate*)GMTDate
{
    OMDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone systemTimeZone]];
    return [NSDate dateFromOMDateInformation:info timeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
}

- (NSDate *)startOfHour
{
    OMDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    info.second = 0;
    return [NSDate dateFromOMDateInformation:info timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate *)startOfDay
{
	return [self startOfDayWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate*)startOfDayWithTimeZone:(NSTimeZone *)tz
{
    OMDateInformation info = [self dateInformationWithTimeZone:tz];
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromOMDateInformation:info timeZone:tz];
}

- (NSDate *)startOfMonth
{
    return [self startOfMonthWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate *)startOfMonthWithTimeZone:(NSTimeZone *)tz
{
    OMDateInformation info = [self dateInformationWithTimeZone:tz];
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
    info.day = 1;
	return [NSDate dateFromOMDateInformation:info timeZone:tz];
}

- (NSDate *)startOfYear
{
    return [self startOfYearWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate *)startOfYearWithTimeZone:(NSTimeZone *)tz
{
    OMDateInformation info = [self dateInformationWithTimeZone:tz];
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
    info.day = 1;
    info.month = 1;
	return [NSDate dateFromOMDateInformation:info timeZone:tz];
}

- (NSDate *)tomorrow
{
    return [self tomorrowWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate *)tomorrowWithTimeZone:(NSTimeZone *)tz
{
    OMDateInformation info = [self dateInformationWithTimeZone:tz];
    NSDate *firstOfdayDate;
    firstOfdayDate = [self startOfMonthWithTimeZone:tz];
    int dayInDate = (int)[firstOfdayDate daysBetweenDate:[firstOfdayDate nextMonth]];
	info.day ++;
    if (info.day > dayInDate) {
        
        info.day = 1;
        info.month ++;
        if (info.month > 12) {
            info.month = 1;
            info.year ++;
        }
    }
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
    return [NSDate dateFromOMDateInformation:info timeZone:tz];
}


- (NSDate*)nextMonth
{
    return [self nextMonthWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate *)nextMonthWithTimeZone:(NSTimeZone *)tz
{
    OMDateInformation info = [self dateInformationWithTimeZone:tz];
	info.month++;
	if(info.month>12){
		info.month = 1;
		info.year++;
	}
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromOMDateInformation:info timeZone:tz];
}

- (NSDate *)nextYear
{
	return [self nextYearWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate *)nextYearWithTimeZone:(NSTimeZone *)tz
{
	OMDateInformation info = [self dateInformationWithTimeZone:tz];
	info.year++;
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromOMDateInformation:info timeZone:tz];
}

- (NSDate *)yesterday
{
    return [self yesterdayWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate *)yesterdayWithTimeZone:(NSTimeZone *)tz
{
    OMDateInformation info = [self dateInformationWithTimeZone:tz];
	info.day --;
    if (info.day < 1) {
        NSDate *firstOfdayDate = [self startOfDayWithTimeZone:tz];
        int dayInPrevMonth = (int)[firstOfdayDate daysBetweenDate:[firstOfdayDate previousMonth]];
        info.day = dayInPrevMonth;
        info.month --;
        if (info.month < 1) {
            info.month = 12;
            info.year --;
        }
    }
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
    return [NSDate dateFromOMDateInformation:info timeZone:tz];
}

- (NSDate*) previousDays:(NSUInteger)days
{
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	OMDateInformation info = [self dateInformationWithTimeZone:tz];
    for (int i = 0; i < days; i ++) {
        info.day --;
        if (info.day < 1) {
            info.day = 1;
            NSDate *firstOfdayDate = [[NSDate dateFromOMDateInformation:info timeZone:tz] startOfMonthWithTimeZone:tz];
            int dayInPrevMonth = (int)[firstOfdayDate daysBetweenDate:[firstOfdayDate previousMonth]];
            info.day = dayInPrevMonth;
            info.month --;
            if (info.month < 1) {
                info.month = 12;
                info.year --;
            }
        }
    }
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
    return [NSDate dateFromOMDateInformation:info timeZone:tz];
}

- (NSDate*)laterDays:(NSUInteger)days
{
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    OMDateInformation info = [self dateInformationWithTimeZone:tz];
    NSDate *firstOfdayDate;
    firstOfdayDate = [self startOfMonthWithTimeZone:tz];
    NSInteger dayInDate = [firstOfdayDate daysBetweenDate:[firstOfdayDate nextMonth]];
    for (int i = 0; i < days; i++) {
        info.day ++;
        if (info.day > dayInDate) {
            
            info.day = 1;
            info.month ++;
            if (info.month > 12) {
                info.month = 1;
                info.year ++;
            }
        }
        info.minute = 0;
        info.second = 0;
        info.hour = 0;
    }
    return [NSDate dateFromOMDateInformation:info timeZone:tz];
    
}

- (NSDate*)weekBefore
{
    return [self weekBeforeWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate*)weekBeforeWithTimeZone:(NSTimeZone *)tz
{
    OMDateInformation info = [self dateInformationWithTimeZone:tz];
    for (int i = 0; i < 7; i++) {
        info.day --;
        if (info.day < 1) {
            NSDate *firstOfdayDate = [self startOfDayWithTimeZone:tz];
            int dayInPrevMonth = (int)[firstOfdayDate daysBetweenDate:[firstOfdayDate previousMonth]];
            info.day = dayInPrevMonth;
            info.month --;
            if (info.month < 1) {
                info.month = 12;
                info.year --;
            }
        }
        info.minute = 0;
        info.second = 0;
        info.hour = 0;
    }
    return [NSDate dateFromOMDateInformation:info timeZone:tz];
}

- (NSDate*) previousMonth
{
	return [self previousMonthWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate*) previousMonthWithTimeZone:(NSTimeZone *)tz
{
	OMDateInformation info = [self dateInformationWithTimeZone:tz];
	info.month--;
	if(info.month<1){
		info.month = 12;
		info.year--;
	}
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromOMDateInformation:info timeZone:tz];
}

- (NSDate*)previousMonthWithNum:(int)num
{
    OMDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    for ( int i = 0; i< num; i++) {
        info.month--;
        if(info.month<1){
            info.month = 12;
            info.year--;
        }
    }
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromOMDateInformation:info timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate*)previousYear
{
    return [self previousYearWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (NSDate*)previousYearWithTimeZone:(NSTimeZone *)tz
{
	OMDateInformation info = [self dateInformationWithTimeZone:tz];
    info.year--;
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromOMDateInformation:info timeZone:tz];
	
}

- (NSDate*)previousYearWithNum:(int)num
{
	OMDateInformation info = [self dateInformation];
    for ( int i = 0; i< num; i++) {
        info.year--;
    }
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
    
	return [NSDate dateFromOMDateInformation:info timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	
}

- (WeekState)weekday
{
    return [self weekdayWithTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

- (WeekState)weekdayWithTimeZone:(NSTimeZone *)tz
{
    OMDateInformation info = [self dateInformationWithTimeZone:tz];
    return info.weekday;
}

- (NSDate*)changeDayInDate:(int)day{
    OMDateInformation info =[self dateInformation];
    info.day = day;
    return [NSDate dateFromOMDateInformation:info timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

+ (NSDate*)stringToDateWithStr:(NSString*)str dateFormate:(NSString*)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:dateFormat];
    NSDate *date = [formatter dateFromString:str];
#if ! __has_feature(objc_arc)
    [formatter release];
#endif

    return date;
}

- (int)dayInDate
{
    OMDateInformation info = [self dateInformation];
    return info.day;
}

- (int)monthInDate
{
    OMDateInformation info = [self dateInformation];
    return info.month;
}

- (int)yearInDate
{
    OMDateInformation info = [self dateInformation];
    return info.year;
}

- (BOOL)isToday
{
    OMDateInformation info1 = [self dateInformation];
    OMDateInformation info2 = [[NSDate date] dateInformation];
    if (info1.year == info2.year && info1.month == info2.month && info1.day == info2.day) {
        return TRUE;
    }
    return FALSE;
}

- (NSString *)dateToLocalStringWithDateFormate:(NSString *)dateForamt
{
    return [self dateToStringWithDateFormate:dateForamt timeZone:[NSTimeZone localTimeZone] locale:[NSLocale systemLocale]];
}

- (NSString*)dateToStringWithDateFormate:(NSString*)dateForamt
{
    return [self dateToStringWithDateFormate:dateForamt timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"] locale:[NSLocale systemLocale]];
}

- (NSString *)dateToStringWithDateFormate:(NSString*)dateForamt timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale
{
    NSString *str = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timezone];
    [formatter setLocale:locale];
	[formatter setDateFormat:dateForamt];
	str = [formatter stringFromDate:self];
#if ! __has_feature(objc_arc)
    [formatter release];
#endif
    return str;
}

- (NSDate *)dateWithDateFromate:(NSString *)dateFormate timeZone:(NSTimeZone *)timezone locale:(NSLocale *)locale
{
    NSString *dateStr = [self dateToStringWithDateFormate:dateFormate timeZone:timezone locale:locale];
    return [dateStr stringWihtDateFormat:dateFormate timeZone:timezone locale:locale];
}

- (NSDate *)dateWithDateFromate:(NSString *)dateFormate
{
    NSString *dateStr = [self dateToStringWithDateFormate:dateFormate];
    return [dateStr stringWihtDateFormat:dateFormate];
}

- (NSString *)zhsDateFormate
{
    /*
     时间表示：
     一分钟内：刚刚
     今天内：小时:分钟
     昨天：昨天
     其他：年-月-日
     */
    NSString *changedString;
    NSInteger betweenDays = [[self startOfDay] daysBetweenDate:[[[NSDate date] UTCDate] startOfDay]];
    if (betweenDays == 0) {
        NSTimeInterval timeInterval = fabs([self timeIntervalSinceDate:[[NSDate date] UTCDate]]);
        if (timeInterval < 60) {
            changedString = @"刚刚";
        } else {
            changedString = [self dateToStringWithDateFormate:@"HH:mm"];
        }
    } else if (betweenDays == 1) {
        changedString = @"昨天";
    } else {
        changedString = [self dateToStringWithDateFormate:@"yyyy-MM-dd"];
    }
    
//    NSTimeInterval timeInterval = fabs([self timeIntervalSinceDate:[[NSDate date] UTCDate]]);
//    if (timeInterval >= 86400) {
//        changedString = (NSInteger)timeInterval / 86400 < 2 ? @"昨天" : [self dateToStringWithDateFormate:@"yyyy-MM-dd"];
//    } else if (timeInterval >= 3600) {
//        changedString = [NSString stringWithFormat:@"%ld小时前", (long)timeInterval / 3600];
//    } else if (timeInterval >= 60) {
//        changedString = [NSString stringWithFormat:@"%ld分钟前", (long)timeInterval / 60];
//    } else if (timeInterval < 60) {
//        changedString = [NSString stringWithFormat:@"刚刚"];
//    }
    return changedString;
}

/*
 G: 公元时代，例如AD公元
 yy: 年的后2位,12
 yyyy: 完整年,2012
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 */

- (BOOL)isCurrentDay:(NSDate *)aDate
{
    if (aDate==nil) return NO;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate])
        return YES;
    
    return NO;
}
@end
