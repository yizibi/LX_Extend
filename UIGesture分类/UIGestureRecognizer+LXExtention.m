
//
//  UIGestureRecognizer+LXExtention.m
//  测试分类
//
//  Created by hspcadmin on 2017/8/2.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import "UIGestureRecognizer+LXExtention.h"
#import <objc/runtime.h>

static const int block_key;

@interface LXUIGestureRecognizerBlockTarget : NSObject


@property (nonatomic, copy) void (^block)(id sender);
- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation LXUIGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id))block{
    if (self = [super init]) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender{
    if (_block) {
        _block(sender);
    }
}


@end

@implementation UIGestureRecognizer (LXExtention)

- (instancetype)initWithActionBlock:(void (^)(id))block{
    self = [self init];
    [self addActionBlock:block];
    return self;
}


- (void)addActionBlock:(void (^)(id))block{
    LXUIGestureRecognizerBlockTarget *target = [[LXUIGestureRecognizerBlockTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self lx_allUIGestureRecognizerTargets];
    [targets addObject:target];
}

- (void)removeAllActionBlocks {
    NSMutableArray *targets = [self lx_allUIGestureRecognizerTargets];
    [targets enumerateObjectsUsingBlock:^(id  _Nonnull target, NSUInteger idx, BOOL * _Nonnull stop) {
        //遍历移除所有的方法
        [self removeTarget:target action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)lx_allUIGestureRecognizerTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
