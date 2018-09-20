//
//  DateManger.m
//  FireControl
//
//  Created by tpson on 2018/3/13.
//  Copyright © 2018年 tpson. All rights reserved.
//

#import "DateManger.h"


@implementation DateManger

implementationSingle(DateManger);

- (id)init
{
    if (self = [super init]) {
        _storage = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark -
// 取到缓存的dateFormatter对象，没有就创建一个并返回
- (NSDateFormatter *)dateFormatterOfDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [_storage objectForKey:dateFormat];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = dateFormat;
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC+8"];
        // 创建NSDateFormatter的过程开销很大,所以这里缓存dateFormatter对象
        [_storage setObject:dateFormatter forKey:dateFormat];
    }
    
    return dateFormatter;
}


#pragma mark -
- (NSString *)stringWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [self dateFormatterOfDateFormat:dateFormat];
    
    return [dateFormatter stringFromDate:date];
}

- (NSString *)stringWithTimeInterval:(NSTimeInterval)interval dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [self dateFormatterOfDateFormat:dateFormat];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:interval];
    
    return [dateFormatter stringFromDate:date];
}

- (NSTimeInterval)timeIntervalWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [self dateFormatterOfDateFormat:dateFormat];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    return [date timeIntervalSince1970];
}

- (NSDate *)dateWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [self dateFormatterOfDateFormat:dateFormat];
    return [dateFormatter dateFromString:dateStr];
}

- (NSString *)timestampWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    // NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    // [formatter setTimeZone:timeZone];
    NSDate* dateTodo = [formatter dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]];
    return timeSp;
    
}

- (NSString *)getNowTimeTimestamp2{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

static NSDateFormatter *fmt_;
static NSCalendar *calendar_;
/**
 *  在第一次使用XMGTopic类时调用1次
 */
+ (void)initialize
{
    fmt_ = [[NSDateFormatter alloc] init];
    calendar_ = [NSCalendar calendar];
}



- (NSDate*)getUSADateWithTimestamp:(id)timestamp {
    NSInteger timeInteger = [timestamp integerValue];
    return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)timeInteger];
}


- (NSString *)timeIntervalDescriptionWithTimestamp:(id)timestamp {
    NSDate *date = [self getUSADateWithTimestamp:timestamp];
    return [self timeIntervalDescriptionWithDateTimestamp:date];
}


- (NSString *)timeIntervalDescriptionWithDateTimestamp:(NSDate*)date {
    NSTimeInterval timeInterval = -[date timeIntervalSinceNow];
    if (timeInterval < 86400) {
        return [NSString stringWithFormat:@"今天 %@",[self stringWithTimeInterval:timeInterval dateFormat:fDF]];
    } else if (timeInterval < 31536000) {//30天至1年内
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"M月d日"];
        return [dateFormatter stringFromDate:date];
    } else {
        return [NSString stringWithFormat:@"%.f年前", timeInterval / 31536000];
    }
}

- (NSString *)dataFormatDefiniteBeforeMinute:(id)timeString {
    return [self timeIntervalDescriptionWithTimestamp:timeString];
}


- (BOOL)isThisYear:(NSData *)currentData
{
    // 判断self这个日期是否为今年
    NSCalendar *calendar = [NSCalendar calendar];
    
    // 年
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:currentData];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return selfYear == nowYear;
}

- (BOOL)isToday:(NSData *)currentData
{
    // 判断self这个日期是否为今天
    NSCalendar *calendar = [NSCalendar calendar];
    
    // 获得年月日元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *selfCmps = [calendar components:unit fromDate:currentData];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    return selfCmps.year == nowCmps.year
    && selfCmps.month == nowCmps.month
    && selfCmps.day == nowCmps.day;
}

//- (BOOL)isToday
//{
//    // 判断self这个日期是否为今天
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyyMMdd";
//
//    NSString *selfString = [fmt stringFromDate:self];
//    NSString *nowString = [fmt stringFromDate:[NSDate date]];
//
//    return [selfString isEqualToString:nowString];
//}

- (BOOL)isYesterday:(NSData *)currentData
{
    // 判断self这个日期是否为昨天
    
    // self == 2015-10-31 23:07:08 -> 2015-10-31 00:00:00
    // now  == 2015-11-01 14:39:20 -> 2015-11-01 00:00:00
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    NSString *selfString = [fmt stringFromDate:currentData]; // 20151031
    NSString *nowString = [fmt stringFromDate:[NSDate date]]; // 20151101
    
    NSDate *selfDate = [fmt dateFromString:selfString]; // 2015-10-31 00:00:00
    NSDate *nowDate = [fmt dateFromString:nowString]; // 2015-11-01 00:00:00
    
    NSCalendar *calendar = [NSCalendar calendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

- (BOOL)isTomorrow
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    NSString *selfString = [fmt stringFromDate:self]; // 20151031
    NSString *nowString = [fmt stringFromDate:[NSDate date]]; // 20151101
    
    NSDate *selfDate = [fmt dateFromString:selfString]; // 2015-10-31 00:00:00
    NSDate *nowDate = [fmt dateFromString:nowString]; // 2015-11-01 00:00:00
    
    NSCalendar *calendar = [NSCalendar calendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == -1;
}

@end


