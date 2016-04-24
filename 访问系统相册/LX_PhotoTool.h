//
//  LX_PhotoTool.h
//  单身汪汪
//
//  Created by 李lucy on 16/1/24.
//  Copyright © 2016年 com.liluxin.test.Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LX_PhotoTool : UIViewController

/**
 *  弹出菜单栏
 */
- (void)changeHeadImageWithOpenLabrayOrCamera;
/**
 *  保存图片到新建相册的相簿中
 */
- (void)savePhotoUtilBtnDidClick;
@end
