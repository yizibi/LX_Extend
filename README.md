# LX_Extend
开发中常用的分类


> 新增 0810 

## RSA加密文件

* 使用方法:

```
NSString *originalString = @"文档虐我千百遍,我待文档如初恋";

//使用.der和.p12中的公钥私钥加密解密
NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];

NSString *encryptStr = [LXRSAEncryptor encryptString:originalString publicKeyWithContentsOfFile:public_key_path];
NSLog(@"加密前:%@", originalString);
NSLog(@"加密后:%@", encryptStr);
NSLog(@"解密后:%@", [LXRSAEncryptor decryptString:encryptStr privateKeyWithContentsOfFile:private_key_path password:nil]);

```

* 打印结果

```
2017-08-10 08:57:10.553 RAS加密解密[70708:4286249] 加密前:文档虐我千百遍,我待文档如初恋
2017-08-10 08:57:10.553 RAS加密解密[70708:4286249] 加密后:V+RGKgYa05nQUabdX9DtFZvECgzXSIsHGrUNPuxNrc8N+aFliqaqxbLugBDrBhMNyiTzoeFO39dgvnQJFlpcWGXQNaKlMmP8z/LJ/MUUtZGT/686ks/Vl5AonA9nXAmGaZeMniYRMlMWZB1EnxM9fMUbz+wByrjAT89ok0ydFcU=
2017-08-10 08:57:15.987 RAS加密解密[70708:4286249] 解密后:文档虐我千百遍,我待文档如初恋

```



## 单例的使用
//备注:name为当前的类名
直接导入'Single.h'头文件,在想设置单例的时候,`.h`文件和`.m`文件分别写入:`interfaceSingle(name)`和`implementationSingle(name)`,使用单例的时候,方法:`[当前类名 share..]`,就可以了,非常简单;
***

##UIImage和UIImageView的扩展方法
包括裁剪圆形图片,可拉伸的图片,根据颜色生成图片,保存本地相册,压缩图片到指定大小,图片的模糊处理等

## UIColor的分类
主要是十六进制颜色转换,判断色值等

##[NSString+LXExtention.h]沙盒路径的获取封装及计算缓存文件大小
直接拖入分类,方法说明:都为对象方法,给定一个NSString,生成对应的路径

```
cachesDir:缓存路径
docDir:文档路径
temDir:临时路径
fileSize:计算缓存文件大小
```

***

## [NSDate和NSCalendar分类]
判断日期,今天,明天等

***

# UIView的分类
说明:通过点语法,便于直接访问UIView的frame

# LX_PhotoTool系统相册相关

> 说明:开发中,有时候会用到,访问系统相册又或者调用相机,用户上传照片或者更改用户头像;还有就是保存网络上的图片到本地中,都较常用,因此整理了相关的方法;

`温馨提示:`LX_PhotoTool文件中只是整理了相关的方法,只是为了方便开发,而不是分类或者可以直接导入项目中,<** 不能直接导入项目 **>

iOS中,关于系统相册的有两个,一个是UIImagePickerController,用于访问相册,相机,另一个是<Photos>系统库
  
### UIImagePickerController的使用注意:

`注意`:此时需要遵守两个代理:

	* UIImagePickerControllerDelegate
	* UINavigationControllerDelegate

### Photo库的使用

`注意`:导入相关头文件:
 
	* #import <AVFoundation/AVFoundation.h>
  	* #import <Photos/Photos.h>

#UIBarButtonItem分类和UIGesture分类

> 说明:系统中的某些类,比如,UIBarButtonItem,初始化的时候,利用的是方法映射,根据方法名--->方法实现,这样做不便于代码维护,以block的形式,是的代码的可读性提高不少;

`温馨提示:` 导入相关头文件

* UIBarButtonItem

    * runtime 添加actionBlock 属性,捕捉用户点击item的事件

```

@property (nonatomic, copy) void (^actionBlock)(id);


```


* UIGesture 

    * runtime 以block的方式,添加初始换方法,支持添加手势,移除所有手势;

```
- (instancetype)initWithActionBlock:(void (^)(id sender))block;

- (void)addActionBlock:(void (^)(id sender))block;

- (void)removeAllActionBlocks;

```

