//
//  LXRSAEncryptor.h
//  RAS加密解密
//
//  Created by hspcadmin on 2017/7/31.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXRSAEncryptor : NSObject


/**
 *  加密方法
 *
 *  @param str   需要加密的字符串
 *  @param path  '.der'格式的公钥文件路径
 */
+ (NSString *)encryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path;

/**
 *  解密方法
 *
 *  @param str       需要解密的字符串
 *  @param path      '.p12'格式的私钥文件路径
 *  @param password  私钥文件密码
 */
+ (NSString *)decryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

/**
 *  加密方法
 *
 *  @param str    需要加密的字符串
 *  @param pubKey 公钥字符串
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

/**
 *  解密方法
 *
 *  @param str     需要解密的字符串
 *  @param privKey 私钥字符串
 */
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;

//加密算法,请保证密钥长度是8,否则后果自负
+ (NSString *)decode3Des:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;
+ (NSString *)encode3Des:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;

@end
