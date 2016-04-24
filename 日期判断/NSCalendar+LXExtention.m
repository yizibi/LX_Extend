//
//  NSCalendar+LXExtention.m
//  MandarinTalk
//
//  Created by 李lucy on 15/11/21.
//  Copyright © 2015年 Lucy. All rights reserved.
//

#import "NSCalendar+LXExtention.h"

@implementation NSCalendar (LXExtention)

+ (instancetype)calendar
{
    NSCalendar *calendar = nil;
    if ([NSCalendar instancesRespondToSelector:@selector(calendarWithIdentifier:)]) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }else{
        calendar = [NSCalendar currentCalendar];
    }
    return calendar;
}

@end
