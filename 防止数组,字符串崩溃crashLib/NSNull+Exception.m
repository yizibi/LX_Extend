//
//  NSNull+Exception.m
//  TestDemo
//
//  Created by 李露鑫 on 16/12/27.
//  Copyright © 2016年 李露鑫. All rights reserved.
//

#import "NSNull+Exception.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSNull (Exception)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("NSNull") swizzleMethod:@selector(length) swizzledSelector:@selector(replace_length)];
        }
    });
}

- (NSInteger)replace_length {
    return 0;
}

@end
