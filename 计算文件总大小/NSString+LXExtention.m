//
//  NSString+LXExtention.m
// 汪汪配
//
//  Created by 李lucy on 15/11/17.
//  Copyright © 2015年 Lucy. All rights reserved.
//

#import "NSString+LXExtention.h"

@implementation NSString (LXExtention)


- (instancetype)cachesDir
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[self lastPathComponent]];
}

- (instancetype)docDir
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[self lastPathComponent]];
}

- (instancetype)temDir
{
    NSString *dir = NSTemporaryDirectory();
    return [dir stringByAppendingPathComponent:[self lastPathComponent]];
}

- (unsigned long long)fileSize
{
    //文件总大小
    unsigned long long size = 0;
    //文件管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    //是否为文件
    BOOL isDictory = NO;
    //判断路径是否存在
    BOOL exists = [manger fileExistsAtPath:self isDirectory:&isDictory];
    if (!exists) return size;
    if (isDictory) {//文件夹
        //文件遍历器,也称迭代器
        NSDirectoryEnumerator *dictEnum = [manger enumeratorAtPath:self];
        //    NSLog(@"%@",dictEnum);
        for (NSString *subPath in dictEnum) {
            NSString *fullPath = [self stringByAppendingPathComponent:subPath];
            size += [manger attributesOfItemAtPath:fullPath error:nil].fileSize;
        }
    }else {//文件
        size += [manger attributesOfItemAtPath:self error:nil].fileSize;

    }
    return size;
}
//- (unsigned long long)fileSize
//{
//    //文件总大小
//    unsigned long long size = 0;
//    //文件管理者
//    NSFileManager *manger = [NSFileManager defaultManager];
//    //文件属性
//    NSDictionary *atts = [manger attributesOfItemAtPath:self error:nil];
//    if ([atts.fileType isEqualToString:NSFileTypeDirectory]) {//文件夹
//        //文件遍历器,也称迭代器
//        NSDirectoryEnumerator *dictEnum = [manger enumeratorAtPath:self];
//        //    NSLog(@"%@",dictEnum);
//        for (NSString *subPath in dictEnum) {
//            NSString *fullPath = [self stringByAppendingPathComponent:subPath];
//            size += [manger attributesOfItemAtPath:fullPath error:nil].fileSize;
//        }
//    }else {//文件
//        size += [manger attributesOfItemAtPath:self error:nil].fileSize;
//        
//    }
//    return size;
//}


@end
