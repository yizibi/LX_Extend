//
//  UIGestureRecognizer+LXExtention.h
//  测试分类
//
//  Created by hspcadmin on 2017/8/2.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (LXExtention)


- (instancetype)initWithActionBlock:(void (^)(id sender))block;

- (void)addActionBlock:(void (^)(id sender))block;

- (void)removeAllActionBlocks;

@end
