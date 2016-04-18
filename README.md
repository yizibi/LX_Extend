# LX_Extend
开发中常用的分类

##单例的使用
//备注:name为当前的类名
直接导入'Single.h'头文件,在想设置单例的时候,`.h`文件和`.m`文件分别写入:`interfaceSingle(name)`和`implementationSingle(name)`,使用单例的时候,方法:`[当前类名 share..]`,就可以了,非常简单;
***

##UIImage和UIImageView的扩展方法
包括裁剪圆形图片,可拉伸的图片,根据颜色生成图片,保存本地相册,压缩图片到指定大小,图片的模糊处理等

##UIColor的分类
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

##[NSDate和NSCalendar分类]
判断日期,今天,明天等

***

#UIView的分类
说明:通过点语法,便于直接访问UIView的frame


