//
//  NSDate+LXExtention.h
//  百思不得姐
//
//  Created by 李lucy on 15/11/21.
//  Copyright © 2015年 Lucy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LXExtention)
/**
 *  是否为今年
 */
- (BOOL)isThisYear;
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
@end
