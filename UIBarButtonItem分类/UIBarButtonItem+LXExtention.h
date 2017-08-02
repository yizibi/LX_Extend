//
//  UIBarButtonItem+LXExtention.h
//  测试分类
//
//  Created by hspcadmin on 2017/8/2.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LXExtention)


@property (nonatomic, copy) void (^actionBlock)(id);

@end
