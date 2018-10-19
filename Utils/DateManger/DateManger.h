//
//  DateManger.h
//  FireControl
//
//  Created by tpson on 2018/3/13.
//  Copyright © 2018年 tpson. All rights reserved.
//

#import <Foundation/Foundation.h>


#define aDF @"yyyy-MM-dd HH:mm:ss"
#define bDF @"yyyyMMddHHmmss"
#define cDF @"yyyy-MM-dd"
#define dDF @"yyyyMMdd"
#define eDF @"MM-dd HH:mm"
#define fDF @"HH:mm"
#define gDF @"yyyy/MM/dd HH:mm"
#define hDF @"yyyy年MM月"
#define jDF @"yyyy-MM"



@interface DateManger : NSObject
{
    NSMutableDictionary *_storage; // 用来存放NSDateFormatter对象
}
interfaceSingle(DateManger);



/**
 返回格式化后的时间字符串adF bDf 具体看头文件
 
 @param date 日期
 @param dateFormat 格式
 @return 格式化后的时间字符串
 */
- (NSString *)stringWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat;


/**
 返回格式化后的时间字符串adF bDf 具体看头文件
 
 @param interval 秒数
 @param dateFormat 格式
 @return 格式化后的时间字符串
 */
- (NSString *)stringWithTimeInterval:(NSTimeInterval)interval dateFormat:(NSString *)dateFormat;


/**
 返回秒数
 
 @param dateStr 时间字符串
 @param dateFormat 时间字符串对应的格式
 @return 秒数
 */
- (NSTimeInterval)timeIntervalWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat;


/**
 返回秒数
 
 @param dateStr 时间字符串
 @param dateFormat 时间字符串对应的格式
 @return 秒数
 */
- (NSDate *)dateWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat;

- (NSString *)timestampWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat;

/**
 返回距离当前的年月
 
 @param dateFormat 时间格式
 @param monthCount 未来月份+1 之前的月份 -1
 @return 秒数
 */
- (NSString *)getMonthWithDateFormat:(NSString *)dateFormat monthCount:(NSInteger)monthCount;

/**
 当前时间戳
 
 @return 当前时间戳
 */
- (NSString *)getNowTimeTimestamp2;

/**
 返回格式化时间:几分钟前,几小时前等
 
 @param timeString 时间戳
 */
- (NSString *)dataFormatDefiniteBeforeMinute:(id)timeString;
/** 时间戳转为北京时间 yyyy-MM-dd HH:mm:ss */
- (NSString *)getChineseTimeWithTimestamp:(id)timestamp;
- (NSString *)timeIntervalDescriptionWithTimestamp:(id)timestamp;
- (NSString *)timeIntervalDescriptionWithDateTimestamp:(NSDate*)date;


@end
