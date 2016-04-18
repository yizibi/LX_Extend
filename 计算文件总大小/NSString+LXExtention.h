//
//  NSString+LXExtention.h
//  百思不得姐
//
//  Created by 李lucy on 15/11/17.
//  Copyright © 2015年 Lucy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LXExtention)

/**
 *  计算文件的总大小
 *
 *  @return 字节数
 */
- (unsigned long long)fileSize;


/**
 *  生成缓存目录的全路径
 */
- (instancetype)cachesDir;
/**
 *  生成文档目录的全路径
 */
- (instancetype)docDir;
/**
 *  生成临时目录的 全路径
 */
- (instancetype)temDir;
@end
