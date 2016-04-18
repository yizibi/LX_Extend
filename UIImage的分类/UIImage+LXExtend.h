//
//  UIImage+LXExtend.h
//  汪汪配
//
//  Created by 李lucy on 15/10/18.
//  Copyright © 2016年 xsteach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LXExtend)
/**
 * 返回一张圆形图片
 */
- (instancetype)circleImage;

/**
 * 返回一张圆形图片
 */
+ (instancetype)circleImageNamed:(NSString *)name;
/** 返回一张拉伸的图片 */
+ (UIImage *)resizeImageWithName:(NSString *)name;

/**  返回一张可自定义拉伸位置的拉伸图片 */
+ (UIImage *)resizeImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/**  根据指定的颜色生成图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithCurrentColor:(UIColor *)color;
/**  获得gif类型的图片数组(不需要写.gif的后缀名) */
+ (NSArray *)imagesWithGifNamed:(NSString *)gifName;

/**  保存图片到本地相册 */
+ (void)saveImageToAlbum:(UIImage *)image;

+ (void)saveImageToAlbumWithUrlStr:(NSString *)urlStr;

/**  旋转图片 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**  压缩图片到指定大小 */
- (UIImage *)scaleImageToSize:(CGSize)size;

- (UIImage *)scaleImageFrame:(CGRect)frame;

/**  压缩图片到指定画质 */
- (UIImage *)scaleImageToQuality:(CGFloat)quality;

/**  生成一张等比例的压缩图 */
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
