//
//  LX_PhotoTool.m
//  单身汪汪
//
//  Created by 李lucy on 16/1/24.
//  Copyright © 2016年 com.liluxin.test.Co.,Ltd. All rights reserved.
//

#import "LX_PhotoTool.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

static NSString * LXAssetCollectionTitle = @"我的应用";

@interface LX_PhotoTool()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** imageView */
@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation LX_PhotoTool



/*********** 用于弹出相册或者相机  ******************/

//弹出菜单栏
- (void)changeHeadImageWithOpenLabrayOrCamera
{
    UIAlertController *actionSheetVc = [UIAlertController alertControllerWithTitle:@"选择" message:@"message" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheetVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击了取消");
    }]];
    
    [actionSheetVc addAction:[UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self openCamera];
    }]];
    [actionSheetVc addAction:[UIAlertAction actionWithTitle:@"打开相册" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        [self openPhotoAlbum];
        
    }]];
    
    [self presentViewController:actionSheetVc animated:YES completion:nil];
}

#pragma mark - 打开相机
- (void)openCamera
{
    NSLog(@"点击了打开相机");
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有权限访问相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if (authStatus == AVAuthorizationStatusAuthorized)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.delegate = self;
            controller.allowsEditing = NO;
            controller.view.tag = 200;
            [self presentViewController:controller
                               animated:YES
                             completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备或系统不支持访问相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted)
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                    controller.delegate = self;
                    controller.allowsEditing = NO;
                    controller.view.tag = 200;
                    [self presentViewController:controller
                                       animated:YES
                                     completion:nil];
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备或系统不支持访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }];
    }
    
}

/**
 *  打开相册
 */
- (void)openPhotoAlbum
{
    NSLog(@"点击了打开相册");
    
    UIImagePickerController *imagePickerVc = [[UIImagePickerController alloc] init];
    imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePickerVc.allowsEditing = YES;
    imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerVc.delegate = self;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}


#pragma mark - 相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取选中的图片
    UIImage *selImage = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //重新设置头像
        NSLog(@"重新设置头像或者上传头像服务器");
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





/***************  用于保存图片到本地创建相册 *********************/
- (void)savePhotoUtilBtnDidClick
{
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        //因为系统权限
        //蒙版提示用户
//        [SVProgressHUD showErrorWithStatus:@"因为系统原因, 无法访问相册"];
        
    } else if (status == PHAuthorizationStatusDenied) {
        // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        NSLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
    } else if (status == PHAuthorizationStatusAuthorized) {
        //已授权
        [self saveImage];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // 用户点击了好
                [self saveImage];
            }
        }];
    }

}


- (void)saveImage
{
    // PHAsset : 一个资源, 比如一张图片\一段视频
    // PHAssetCollection : 一个相簿
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存图片A到"相机胶卷"中
        // 创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success == NO) {
            [self showError:@"保存图片失败!"];
            return;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        if (createdAssetCollection == nil) {
            [self showError:@"创建相簿失败!"];
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 3.添加"相机胶卷"中的图片A到"相簿"D中
            
            // 获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            
            // 添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 添加图片到相簿
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success == NO) {
                [self showError:@"保存图片失败!"];;
            } else {
                [self showSuccess:@"保存图片成功!"];;
            }
        }];
    }];
}

/**
 *  获得相簿
 */
- (PHAssetCollection *)createdAssetCollection
{
    // 从已存在相簿中查找这个应用对应的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:LXAssetCollectionTitle]) {
            return assetCollection;
        }
    }
    
    // 没有找到对应的相簿, 得创建新的相簿
    // 错误信息
    NSError *error = nil;
    
    // PHAssetCollection的标识, 利用这个标识可以找到对应的PHAssetCollection对象(相簿对象)
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:LXAssetCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    // 如果有错误信息
    if (error) return nil;
    
    // 获得刚才创建的相簿
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}

- (void)showSuccess:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //蒙版提示
        [SVProgressHUD showSuccessWithStatus:text];
        
    });
}

- (void)showError:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //蒙版提示
        [SVProgressHUD showErrorWithStatus:text];
        
    });
}

@end
