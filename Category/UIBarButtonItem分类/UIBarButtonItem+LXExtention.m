//
//  UIBarButtonItem+LXExtention.m
//  测试分类
//
//  Created by hspcadmin on 2017/8/2.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import "UIBarButtonItem+LXExtention.h"
#import <objc/message.h>
#import <objc/runtime.h>


static const int block_key;

@interface LX_UIBarButtonItemBlocktarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation LX_UIBarButtonItemBlocktarget

- (id)initWithBlock:(void (^)(id))block{
    if (self = [super init]) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender{
    if (self.block) self.block(sender);
}

@end


@implementation UIBarButtonItem (LXExtention)

- (void)setActionBlock:(void (^)(id))block{
    LX_UIBarButtonItemBlocktarget *target = [[LX_UIBarButtonItemBlocktarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &block_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
    
}

- (void (^)(id))actionBlock{
    LX_UIBarButtonItemBlocktarget *target = objc_getAssociatedObject(self, &block_key);
    return target.block;
}

@end
