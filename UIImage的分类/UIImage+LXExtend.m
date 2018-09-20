//
//  UIImage+LXExtend.m
//  汪汪配
//
//  Created by 李lucy on 16/1/18.
//  Copyright © 2016年 xsteach. All rights reserved.
//

#import "UIImage+LXExtend.h"
#import <ImageIO/ImageIO.h>

#define Default_ImageWidth SCREEN_WIDTH
#define Default_ImageHeight 64
#define Default_ImageSize CGSizeMake(Default_ImageWidth, Default_ImageHeight)

@implementation UIImage (LXExtend)

- (instancetype)circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 矩形框
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 添加一个圆
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪(裁剪成刚才添加的图形形状)
    CGContextClip(ctx);
    
    // 往圆上面画一张图片
    [self drawInRect:rect];
    
    // 获得上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] circleImage];
}

/**
 *  返回一张拉伸的图片
 */
+ (UIImage *)resizeImageWithName:(NSString *)name {
    return [self resizeImageWithName:name left:0.5 top:0.5];
}

/**
 *  返回一张可自定义拉伸位置的拉伸图片
 */
+ (UIImage *)resizeImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top {
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

// 给图片添加标记
+ (UIImage *)imageWithOriginalName:(UIImage *)image signColor:(UIColor *)signColor signPositionX:(double)positionX ignPositionY:(double)positionY {
    
    //1.获取图片
    UIImage *signalImage = [[UIImage imageWithColor:signColor] circleImag];
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //3.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //绘制标记图片到当前上下文
    CGFloat signX = positionX * image.size.width;
    CGFloat signY = (1 - positionY)* image.size.height;
    
    CGRect rect = CGRectMake(signX, signY, 40, 40);
    [signalImage drawInRect:rect];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

/**
 *  根据指定的颜色生成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    if (!color) return nil;
    
    CGSize currentSize = Default_ImageSize;
    if (size.width !=0 && size.height !=0) {
        currentSize = size;
    }
    UIGraphicsBeginImageContextWithOptions(currentSize, YES, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, CGRectMake(0, 0, currentSize.width, currentSize.height));
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillPath(ctx);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    return [self imageWithColor:color size:CGSizeZero];
}

+ (UIImage *)imageWithCurrentColor:(UIColor *)color{
    // 描述矩形
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}
#pragma mark - 解析GIF图片
/**
 *  获得gif类型的图片数组(不需要写.gif的后缀名)
 */
+ (NSArray *)imagesWithGifNamed:(NSString *)gifName{
    if (!gifName) return nil;
    
    if ([gifName containsString:@".gif"]) {
        NSRange range = [gifName rangeOfString:@".gif"];
        gifName = [gifName substringToIndex:range.location];
    }
    
    NSData *imagesData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]];
    
    NSMutableArray *imagesArray = [self praseGIFDataToImageArray:imagesData];
    
    return [imagesArray copy];
}

/**
 *  解析GIF成图片数组
 */
+ (NSMutableArray *)praseGIFDataToImageArray:(NSData *)data;
{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
}

#pragma mark - 保存图片
/**
 *  保存图片到本地相册
 *
 *  @param image 要保存的照片
 */
+ (void)saveImageToAlbum:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

/**
 *  根据UrlString下载图片并将其保存到相册
 */
+ (void)saveImageToAlbumWithUrlStr:(NSString *)urlStr{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    UIImage *image = [UIImage imageWithData:data];
    [self saveImageToAlbum:image];
}

/**
 *  是否保存成功
 */
+ (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }
    else{
        message = [error description];
    }
}

/**
 *  旋转图片
 */
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  压缩图片
 */
- (UIImage *)scaleImageToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGFloat x = (SCREEN_WIDTH - size.width) * 0.5;
    CGFloat y = (SCREEN_HEIGHT - size.height) * 0.5;
    [self drawInRect:CGRectMake(x, y, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaleImageFrame:(CGRect)frame{
    CGSize size = frame.size;
    UIGraphicsBeginImageContext(size);
    [self drawInRect:frame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  压缩图片到指定画质
 */
- (UIImage *)scaleImageToQuality:(CGFloat)quality{
    NSData *newImageData = UIImageJPEGRepresentation(self, quality);
    return [UIImage imageWithData:newImageData];
}

/**
 *  生成一张等比例的压缩图
 */
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor)
        {
            scaleFactor = widthFactor;
        }
        else
        {
            scaleFactor = heightFactor;
        }
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }
        else if(widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 2);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
