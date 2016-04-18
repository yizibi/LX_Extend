
//
//  Single.h
//  02-单例模式 
//
//  Created by 李lucy on 15/9/30.
//  Copyright © 2015年 Lucy. All rights reserved.
//



//#define SingleH(name) +(instancatype)share##name
//
//#if __has_feature(objc_arc)
//
//#define SingleM(name) +(instancatype)share##name\
//{\
//    return [[self alloc]init];\
//}\
//static id *_instance;\
//+ (instancetype)allocWithZone:(struct _NSZone *)zone\
//{\
//    static dispatch_once_t onceToken;\
//    dispatch_once(&onceToken, ^{\
//        _instance = [super allocWithZone:zone];\
//    });\
//    return _instance;\
//}\
//- (id)copyWithZone:(struct _NSZone *)zone\
//{\
//    return _instance;\
//}\
//- (id)mutableCopyWithZone:(struct _NSZone *)zone\
//{\
//    return _instance;\
//}
//#else
////MRC
//#define SingleM(name) +(instancatype)share##name\
//{\
//    return [[self alloc]init];\
//}\
//static id *_instance;\
//+ (instancetype)allocWithZone:(struct _NSZone *)zone\
//{\
//    static dispatch_once_t onceToken;\
//    dispatch_once(&onceToken, ^{\
//        _instance = [super allocWithZone:zone];\
//    });\
//    return _instance;\
//}\
//- (id)copyWithZone:(struct _NSZone *)zone\
//{\
//    return _instance;\
//}\
//- (id)mutableCopyWithZone:(struct _NSZone *)zone\
//{\
//    return _instance;\
//}\
//- (oneway void)release\
//{}\
//- (instancetype)retain\
//{\
//    return _instance;\
//}\
//- (NSUInteger)retainCount\
//{\
//    return MAXFLOAT;\
//}
//#endif
#define interfaceSingle(name)  + (instancetype)share##name

#if __has_feature(objc_arc)
// 如果是ARC
#define implementationSingle(name)  + (instancetype)share##name \
{ \
return [[self alloc] init]; \
} \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
return _instance; \
}
#else
// 如果不是ARC
#define implementationSingle(name)  + (instancetype)share##name \
{ \
return [[self alloc] init]; \
} \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
return _instance; \
}\
- (oneway void)release \
{} \
- (instancetype)retain \
{ \
return _instance; \
} \
- (NSUInteger)retainCount \
{ \
return MAXFLOAT; \
}
#endif
