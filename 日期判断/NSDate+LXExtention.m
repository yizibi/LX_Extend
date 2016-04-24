//
//  NSDate+LXExtention.m
// MandarinTalk
//
//  Created by 李lucy on 15/11/21.
//  Copyright © 2015年 Lucy. All rights reserved.
//

#import "NSDate+LXExtention.h"

@implementation NSDate (LXExtention)

//是否为今年
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar calendar];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    return selfYear == nowYear;
}
//是否为今天
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar calendar];
    //获得日期元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comSelf = [calendar components:unit fromDate:self];
    NSDateComponents *comNow = [calendar components:unit fromDate:[NSDate date]];
    
    return comSelf.year == comNow.year  &&
          comSelf.month == comNow.month &&
            comSelf.day == comNow.day;
}
//是否为昨天
- (BOOL)isYesterday
{
    //利用日期比较,先将日期转换为字符串,然后在转换为日期,目的是为了屏蔽日期之后的时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfString = [fmt stringFromDate:self];
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    NSCalendar *calendar = [NSCalendar calendar];
    //获得日期元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *coms = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return coms.year == 0 &&
          coms.month == 0 &&
            coms.day == 1;
    
}

//是否为明天
- (BOOL)isTommrow
{
        //利用日期比较,先将日期转换为字符串,然后在转换为日期,目的是为了屏蔽日期之后的时间
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyyMMdd";
        NSString *selfString = [fmt stringFromDate:self];
        NSString *nowString = [fmt stringFromDate:[NSDate date]];
        
        NSDate *selfDate = [fmt dateFromString:selfString];
        NSDate *nowDate = [fmt dateFromString:nowString];
        NSCalendar *calendar = [NSCalendar calendar];
        //获得日期元素
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *coms = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
        return coms.year == 0 &&
        coms.month == 0 &&
        coms.day == -1;
}

@end
