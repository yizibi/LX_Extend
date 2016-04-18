//
//  UIColor+hp_Extension.h
//  Fashion
//
//  Created by 李露鑫 on 15/10/27.
//  Copyright (c) 2015年 李露鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hp_Extension)
/** 判断颜色值是否相同 */
- (BOOL)isEqualToColor:(UIColor *)otherColor;

+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
