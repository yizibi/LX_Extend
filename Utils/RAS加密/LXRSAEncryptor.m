

//
//  LXRSAEncryptor.m
//  RAS加密解密
//
//  Created by hspcadmin on 2017/7/31.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import "LXRSAEncryptor.h"
#import <Security/Security.h>
#import "Base64.h"

#define BLOCK_SIZE 8


short bytebit[8]  = {
    0200, 0100, 040, 020, 010, 04, 02, 01
};

unsigned long bigbyte[24] = {
    0x800000, 0x400000, 0x200000, 0x100000,
    0x80000, 0x40000, 0x20000, 0x10000,
    0x8000, 0x4000, 0x2000, 0x1000,
    0x800, 0x400, 0x200, 0x100,
    0x80, 0x40, 0x20, 0x10,
    0x8, 0x4, 0x2, 0x1
};

/*
 * Use the key schedule specified in the Standard (ANSI X3.92-1981).
 */

unsigned char pc1[56] = {
    56, 48, 40, 32, 24, 16, 8, 0, 57, 49, 41, 33, 25, 17,
    9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35,
    62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21,
    13, 5, 60, 52, 44, 36, 28, 20, 12, 4, 27, 19, 11, 3
};

unsigned char totrot[16] = {
    1, 2, 4, 6, 8, 10, 12, 14,
    15, 17, 19, 21, 23, 25, 27, 28
};

unsigned char pc2[48] = {
    13, 16, 10, 23, 0, 4, 2, 27, 14, 5, 20, 9,
    22, 18, 11, 3, 25, 7, 15, 6, 26, 19, 12, 1,
    40, 51, 30, 36, 46, 54, 29, 39, 50, 44, 32, 47,
    43, 48, 38, 55, 33, 52, 45, 41, 49, 35, 28, 31
};

unsigned long SP1[64] = {
    0x01010400, 0x00000000, 0x00010000, 0x01010404,
    0x01010004, 0x00010404, 0x00000004, 0x00010000,
    0x00000400, 0x01010400, 0x01010404, 0x00000400,
    0x01000404, 0x01010004, 0x01000000, 0x00000004,
    0x00000404, 0x01000400, 0x01000400, 0x00010400,
    0x00010400, 0x01010000, 0x01010000, 0x01000404,
    0x00010004, 0x01000004, 0x01000004, 0x00010004,
    0x00000000, 0x00000404, 0x00010404, 0x01000000,
    0x00010000, 0x01010404, 0x00000004, 0x01010000,
    0x01010400, 0x01000000, 0x01000000, 0x00000400,
    0x01010004, 0x00010000, 0x00010400, 0x01000004,
    0x00000400, 0x00000004, 0x01000404, 0x00010404,
    0x01010404, 0x00010004, 0x01010000, 0x01000404,
    0x01000004, 0x00000404, 0x00010404, 0x01010400,
    0x00000404, 0x01000400, 0x01000400, 0x00000000,
    0x00010004, 0x00010400, 0x00000000, 0x01010004
};

unsigned long SP2[64] = {
    0x80108020, 0x80008000, 0x00008000, 0x00108020,
    0x00100000, 0x00000020, 0x80100020, 0x80008020,
    0x80000020, 0x80108020, 0x80108000, 0x80000000,
    0x80008000, 0x00100000, 0x00000020, 0x80100020,
    0x00108000, 0x00100020, 0x80008020, 0x00000000,
    0x80000000, 0x00008000, 0x00108020, 0x80100000,
    0x00100020, 0x80000020, 0x00000000, 0x00108000,
    0x00008020, 0x80108000, 0x80100000, 0x00008020,
    0x00000000, 0x00108020, 0x80100020, 0x00100000,
    0x80008020, 0x80100000, 0x80108000, 0x00008000,
    0x80100000, 0x80008000, 0x00000020, 0x80108020,
    0x00108020, 0x00000020, 0x00008000, 0x80000000,
    0x00008020, 0x80108000, 0x00100000, 0x80000020,
    0x00100020, 0x80008020, 0x80000020, 0x00100020,
    0x00108000, 0x00000000, 0x80008000, 0x00008020,
    0x80000000, 0x80100020, 0x80108020, 0x00108000
};

unsigned long SP3[64] = {
    0x00000208, 0x08020200, 0x00000000, 0x08020008,
    0x08000200, 0x00000000, 0x00020208, 0x08000200,
    0x00020008, 0x08000008, 0x08000008, 0x00020000,
    0x08020208, 0x00020008, 0x08020000, 0x00000208,
    0x08000000, 0x00000008, 0x08020200, 0x00000200,
    0x00020200, 0x08020000, 0x08020008, 0x00020208,
    0x08000208, 0x00020200, 0x00020000, 0x08000208,
    0x00000008, 0x08020208, 0x00000200, 0x08000000,
    0x08020200, 0x08000000, 0x00020008, 0x00000208,
    0x00020000, 0x08020200, 0x08000200, 0x00000000,
    0x00000200, 0x00020008, 0x08020208, 0x08000200,
    0x08000008, 0x00000200, 0x00000000, 0x08020008,
    0x08000208, 0x00020000, 0x08000000, 0x08020208,
    0x00000008, 0x00020208, 0x00020200, 0x08000008,
    0x08020000, 0x08000208, 0x00000208, 0x08020000,
    0x00020208, 0x00000008, 0x08020008, 0x00020200
};

unsigned long SP4[64] = {
    0x00802001, 0x00002081, 0x00002081, 0x00000080,
    0x00802080, 0x00800081, 0x00800001, 0x00002001,
    0x00000000, 0x00802000, 0x00802000, 0x00802081,
    0x00000081, 0x00000000, 0x00800080, 0x00800001,
    0x00000001, 0x00002000, 0x00800000, 0x00802001,
    0x00000080, 0x00800000, 0x00002001, 0x00002080,
    0x00800081, 0x00000001, 0x00002080, 0x00800080,
    0x00002000, 0x00802080, 0x00802081, 0x00000081,
    0x00800080, 0x00800001, 0x00802000, 0x00802081,
    0x00000081, 0x00000000, 0x00000000, 0x00802000,
    0x00002080, 0x00800080, 0x00800081, 0x00000001,
    0x00802001, 0x00002081, 0x00002081, 0x00000080,
    0x00802081, 0x00000081, 0x00000001, 0x00002000,
    0x00800001, 0x00002001, 0x00802080, 0x00800081,
    0x00002001, 0x00002080, 0x00800000, 0x00802001,
    0x00000080, 0x00800000, 0x00002000, 0x00802080
};

unsigned long SP5[64] = {
    0x00000100, 0x02080100, 0x02080000, 0x42000100,
    0x00080000, 0x00000100, 0x40000000, 0x02080000,
    0x40080100, 0x00080000, 0x02000100, 0x40080100,
    0x42000100, 0x42080000, 0x00080100, 0x40000000,
    0x02000000, 0x40080000, 0x40080000, 0x00000000,
    0x40000100, 0x42080100, 0x42080100, 0x02000100,
    0x42080000, 0x40000100, 0x00000000, 0x42000000,
    0x02080100, 0x02000000, 0x42000000, 0x00080100,
    0x00080000, 0x42000100, 0x00000100, 0x02000000,
    0x40000000, 0x02080000, 0x42000100, 0x40080100,
    0x02000100, 0x40000000, 0x42080000, 0x02080100,
    0x40080100, 0x00000100, 0x02000000, 0x42080000,
    0x42080100, 0x00080100, 0x42000000, 0x42080100,
    0x02080000, 0x00000000, 0x40080000, 0x42000000,
    0x00080100, 0x02000100, 0x40000100, 0x00080000,
    0x00000000, 0x40080000, 0x02080100, 0x40000100
};

unsigned long SP6[64] = {
    0x20000010, 0x20400000, 0x00004000, 0x20404010,
    0x20400000, 0x00000010, 0x20404010, 0x00400000,
    0x20004000, 0x00404010, 0x00400000, 0x20000010,
    0x00400010, 0x20004000, 0x20000000, 0x00004010,
    0x00000000, 0x00400010, 0x20004010, 0x00004000,
    0x00404000, 0x20004010, 0x00000010, 0x20400010,
    0x20400010, 0x00000000, 0x00404010, 0x20404000,
    0x00004010, 0x00404000, 0x20404000, 0x20000000,
    0x20004000, 0x00000010, 0x20400010, 0x00404000,
    0x20404010, 0x00400000, 0x00004010, 0x20000010,
    0x00400000, 0x20004000, 0x20000000, 0x00004010,
    0x20000010, 0x20404010, 0x00404000, 0x20400000,
    0x00404010, 0x20404000, 0x00000000, 0x20400010,
    0x00000010, 0x00004000, 0x20400000, 0x00404010,
    0x00004000, 0x00400010, 0x20004010, 0x00000000,
    0x20404000, 0x20000000, 0x00400010, 0x20004010
};

unsigned long SP7[64] = {
    0x00200000, 0x04200002, 0x04000802, 0x00000000,
    0x00000800, 0x04000802, 0x00200802, 0x04200800,
    0x04200802, 0x00200000, 0x00000000, 0x04000002,
    0x00000002, 0x04000000, 0x04200002, 0x00000802,
    0x04000800, 0x00200802, 0x00200002, 0x04000800,
    0x04000002, 0x04200000, 0x04200800, 0x00200002,
    0x04200000, 0x00000800, 0x00000802, 0x04200802,
    0x00200800, 0x00000002, 0x04000000, 0x00200800,
    0x04000000, 0x00200800, 0x00200000, 0x04000802,
    0x04000802, 0x04200002, 0x04200002, 0x00000002,
    0x00200002, 0x04000000, 0x04000800, 0x00200000,
    0x04200800, 0x00000802, 0x00200802, 0x04200800,
    0x00000802, 0x04000002, 0x04200802, 0x04200000,
    0x00200800, 0x00000000, 0x00000002, 0x04200802,
    0x00000000, 0x00200802, 0x04200000, 0x00000800,
    0x04000002, 0x04000800, 0x00000800, 0x00200002
};

unsigned long SP8[64] = {
    0x10001040, 0x00001000, 0x00040000, 0x10041040,
    0x10000000, 0x10001040, 0x00000040, 0x10000000,
    0x00040040, 0x10040000, 0x10041040, 0x00041000,
    0x10041000, 0x00041040, 0x00001000, 0x00000040,
    0x10040000, 0x10000040, 0x10001000, 0x00001040,
    0x00041000, 0x00040040, 0x10040040, 0x10041000,
    0x00001040, 0x00000000, 0x00000000, 0x10040040,
    0x10000040, 0x10001000, 0x00041040, 0x00040000,
    0x00041040, 0x00040000, 0x10041000, 0x00001000,
    0x00000040, 0x10040040, 0x00001000, 0x00041040,
    0x10001000, 0x00000040, 0x10000040, 0x10040000,
    0x10040040, 0x10000000, 0x00040000, 0x10001040,
    0x00000000, 0x10041040, 0x00040040, 0x10000040,
    0x10040000, 0x10001000, 0x10001040, 0x00000000,
    0x10041040, 0x00041000, 0x00041000, 0x00001040,
    0x00001040, 0x00040040, 0x10000000, 0x10041000
};

@implementation LXRSAEncryptor

static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

#pragma mark - 使用'.der'公钥文件加密

//加密
+ (NSString *)encryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path{
    if (!str || !path)  return nil;
    return [self encryptString:str publicKeyRef:[self getPublicKeyRefWithContentsOfFile:path]];
}

//获取公钥
+ (SecKeyRef)getPublicKeyRefWithContentsOfFile:(NSString *)filePath{
    NSData *certData = [NSData dataWithContentsOfFile:filePath];
    if (!certData) {
        return nil;
    }
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    SecKeyRef key = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    key = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return key;
}

+ (NSString *)encryptString:(NSString *)str publicKeyRef:(SecKeyRef)publicKeyRef{
    if(![str dataUsingEncoding:NSUTF8StringEncoding]){
        return nil;
    }
    if(!publicKeyRef){
        return nil;
    }
    NSData *data = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:publicKeyRef];
    NSString *ret = base64_encode_data(data);
    return ret;
}

#pragma mark - 使用'.12'私钥文件解密

//解密
+ (NSString *)decryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password{
    if (!str || !path) return nil;
    if (!password) password = @"";
    return [self decryptString:str privateKeyRef:[self getPrivateKeyRefWithContentsOfFile:path password:password]];
}

//获取私钥
+ (SecKeyRef)getPrivateKeyRefWithContentsOfFile:(NSString *)filePath password:(NSString*)password{
    
    NSData *p12Data = [NSData dataWithContentsOfFile:filePath];
    if (!p12Data) {
        return nil;
    }
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    
    return privateKeyRef;
}

+ (NSString *)decryptString:(NSString *)str privateKeyRef:(SecKeyRef)privKeyRef{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!privKeyRef) {
        return nil;
    }
    data = [self decryptData:data withKeyRef:privKeyRef];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

#pragma mark - 使用公钥字符串加密

/* START: Encryption with RSA public key */

//使用公钥字符串加密
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey{
    NSData *data = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}

+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self encryptData:data withKeyRef:keyRef];
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

/* END: Encryption with RSA public key */

#pragma mark - 使用私钥字符串解密

/* START: Decryption with RSA private key */

//使用私钥字符串解密
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey{
    if (!str) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self decryptData:data privateKey:privKey];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self decryptData:data withKeyRef:keyRef];
}

+ (SecKeyRef)addPrivateKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 22; //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

/* END: Decryption with RSA private key */


#pragma mark -
#pragma mark 3DES
unsigned long *generateWorkingKey(BOOL encrypting,const char* key)
{
    unsigned long pc1m[2] = {0},pcr[2] = {0};
    for(int j=0; j<28; j++){
        unsigned int l = pc1[j];
        unsigned long mask = (key[l >> 3] & bytebit[l & 07])?1:0;
        pc1m[0]|= (mask<<j);
        
        l = pc1[j+28];
        mask = (key[l >> 3] & bytebit[l & 07])?1:0;
        pc1m[1]|= (mask<<j);
    }
    
    unsigned long * newKey = (unsigned long *)malloc(sizeof(unsigned long)*32);
    for (int i = 0; i < 16; i++) {
        unsigned int l, m, n;
        if (encrypting) {
            m = i << 1;
        }
        else {
            m = (15 - i) << 1;
        }
        n = m + 1;
        newKey[m] = newKey[n] = 0;
        
        for (int j = 0; j < 28; j++) {
            l = j + totrot[i];
            l = l < 28?l:l-28;
            
            long mask = 0x1<<l;
            long maskAdd = (0x1<<j);
            if(pc1m[0]&mask)
            {
                pcr[0] |= maskAdd;
            }
            else
            {
                pcr[0] &= ~maskAdd;
            }
            
            l = j + 28 + totrot[i];
            l = l<56?l:l-28;
            l -= 28;
            
            mask = 0x1<<l;
            if(pc1m[1]&mask)
            {
                pcr[1] |= maskAdd;
            }
            else
            {
                pcr[1] &= ~maskAdd;
            }
        }
        
        for (int j = 0; j < 24; j++) {
            long offset = pc2[j];
            
            if (pcr[offset/28]&(0x1<<(offset%28))) {
                newKey[m] |= bigbyte[j];
            }
            offset = pc2[j + 24];
            if (pcr[offset/28]&(0x1<<(offset%28))) {
                newKey[n] |= bigbyte[j];
            }
        }//for
    }
    
    for (int i = 0; i != 32; i += 2) {
        unsigned int i1, i2;
        
        i1 = newKey[i];
        i2 = newKey[i + 1];
        
        newKey[i] = ( (i1 & 0x00fc0000) << 6) | ( (i1 & 0x00000fc0) << 10)
        | ( (i2 & 0x00fc0000) >> 10) | ( (i2 & 0x00000fc0) >> 6);
        
        newKey[i + 1] = ( (i1 & 0x0003f000) << 12) | ( (i1 & 0x0000003f) << 16)
        | ( (i2 & 0x0003f000) >> 4) | (i2 & 0x0000003f);
    }
    
    return newKey;
}

void desFunc(unsigned long * wKey,int keyLength,const char * inBuf,int inLength,int inOff,
             unsigned char * outBuf,int outLength,int outOff)
{
    if (wKey == NULL||(inOff + BLOCK_SIZE) > inLength ||(outOff + BLOCK_SIZE) > outLength)
        return;
    
    unsigned int work, right, left;
    
    left = (inBuf[inOff + 0] & 0xff) << 24;
    left |= (inBuf[inOff + 1] & 0xff) << 16;
    left |= (inBuf[inOff + 2] & 0xff) << 8;
    left |= (inBuf[inOff + 3] & 0xff);
    
    right = (inBuf[inOff + 4] & 0xff) << 24;
    right |= (inBuf[inOff + 5] & 0xff) << 16;
    right |= (inBuf[inOff + 6] & 0xff) << 8;
    right |= (inBuf[inOff + 7] & 0xff);
    
    work = ( (left >> 4) ^ right) & 0x0f0f0f0f;
    right ^= work;
    left ^= (work << 4);
    work = ( (left >> 16) ^ right) & 0x0000ffff;
    right ^= work;
    left ^= (work << 16);
    work = ( (right >> 2) ^ left) & 0x33333333;
    left ^= work;
    right ^= (work << 2);
    work = ( (right >> 8) ^ left) & 0x00ff00ff;
    left ^= work;
    right ^= (work << 8);
    right = ( (right << 1) | ( (right >> 31) & 1)) & 0xffffffff;
    work = (left ^ right) & 0xaaaaaaaa;
    left ^= work;
    right ^= work;
    left = ( (left << 1) | ( (left >> 31) & 1)) & 0xffffffff;
    
    for (int round = 0; round < 8; round++) {
        int fval;
        
        work = (right << 28) | (right >> 4);
        work ^= wKey[round * 4 + 0];
        fval = SP7[work & 0x3f];
        fval |= SP5[ (work >> 8) & 0x3f];
        fval |= SP3[ (work >>16) & 0x3f];
        fval |= SP1[ (work >>24) & 0x3f];
        work = right ^ wKey[round * 4 + 1];
        fval |= SP8[work & 0x3f];
        fval |= SP6[ (work >> 8) & 0x3f];
        fval |= SP4[ (work >> 16) & 0x3f];
        fval |= SP2[ (work >> 24) & 0x3f];
        left ^= fval;
        work = (left << 28) | (left >>4);
        work ^= wKey[round * 4 + 2];
        fval = SP7[work & 0x3f];
        fval |= SP5[ (work >> 8) & 0x3f];
        fval |= SP3[ (work >> 16) & 0x3f];
        fval |= SP1[ (work >> 24) & 0x3f];
        work = left ^ wKey[round * 4 + 3];
        fval |= SP8[work & 0x3f];
        fval |= SP6[ (work >> 8) & 0x3f];
        fval |= SP4[ (work >> 16) & 0x3f];
        fval |= SP2[ (work >> 24) & 0x3f];
        right ^= fval;
    }
    
    right = (right << 31) | (right >> 1);
    work = (left ^ right) & 0xaaaaaaaa;
    left ^= work;
    right ^= work;
    left = (left << 31) | (left >> 1);
    work = ( (left >> 8) ^ right) & 0x00ff00ff;
    right ^= work;
    left ^= (work << 8);
    work = ( (left >> 2) ^ right) & 0x33333333;
    right ^= work;
    left ^= (work << 2);
    work = ( (right >> 16) ^ left) & 0x0000ffff;
    left ^= work;
    right ^= (work << 16);
    work = ( (right >> 4) ^ left) & 0x0f0f0f0f;
    left ^= work;
    right ^= (work << 4);
    
    outBuf[outOff + 0] = (uint8_t) ( (right >> 24) & 0xff);
    outBuf[outOff + 1] = (uint8_t) ( (right >> 16) & 0xff);
    outBuf[outOff + 2] = (uint8_t) ( (right >> 8) & 0xff);
    outBuf[outOff + 3] = (uint8_t) (right & 0xff);
    outBuf[outOff + 4] = (uint8_t) ( (left >> 24) & 0xff);
    outBuf[outOff + 5] = (uint8_t) ( (left >> 16) & 0xff);
    outBuf[outOff + 6] = (uint8_t) ( (left >> 8) & 0xff);
    outBuf[outOff + 7] = (uint8_t) (left & 0xff);
}

char * encryptEncode(const char* src,const char* key,int * outLength)
{
    unsigned long * workingKey = generateWorkingKey(YES,key);
    unsigned long    workingKeyLength = (unsigned long)strlen(key);
    
    int length = *outLength;
    
    int processTimes = length / BLOCK_SIZE;
    int leftdata = length % BLOCK_SIZE;
    int bufLength = BLOCK_SIZE * (processTimes + 1);
    
    unsigned char *buf = (unsigned char *)malloc(bufLength+BLOCK_SIZE + 1);
    if(NULL == buf)
    {
        free(workingKey);
        return NULL;
    }
    
    int olen = 0;
    for (int i = 0; i < processTimes; i++) {
        desFunc(workingKey,workingKeyLength,src,length,olen ,buf,bufLength,olen);
        olen += BLOCK_SIZE;
    }
    
    {
        char * temp = (char*)&buf[bufLength];
        for (int j = 0; j < leftdata; j++) {
            temp[j] = src[j + olen];
        }
        for (int k = leftdata; k < BLOCK_SIZE; k++) {
            temp[k] = (char) (BLOCK_SIZE - leftdata);
        }
        temp[BLOCK_SIZE] = '\0';
        
        desFunc(workingKey,workingKeyLength ,temp,BLOCK_SIZE + 1 ,0,buf ,bufLength,olen);
        
        olen += BLOCK_SIZE;
    }
    
    free(workingKey);
    
    char *result = (char*)malloc(olen+1);
    
    result[olen] = '\0';
    for (int j = 0; j < olen; j++) {
        result[j] = buf[j];
    }
    
    *outLength = olen;
    free(buf);
    
    return result;
}


char * decryptEncode(const char* src,const char* key,int* outLength)
{
    unsigned long * workingKey = generateWorkingKey(NO,key);
    unsigned long    workingKeyLength = (unsigned long)strlen(key);
    
    
    int length = *outLength;
    int processTimes = length / BLOCK_SIZE;
    int leftdata =length % BLOCK_SIZE;
    
    if (leftdata != 0) {
        free(workingKey);
        return NULL;
    }
    
    unsigned char *buf = (unsigned char *)malloc(length + 1);
    int olen = 0;
    for (int i = 0; i < processTimes; i++) {
        olen = i * BLOCK_SIZE;
        desFunc(workingKey,workingKeyLength,src,length,olen ,buf ,length,olen);
    }
    
    free(workingKey);
    
    unsigned char bt;
    for (int j = 0; j < BLOCK_SIZE; j++) {
        bt = buf[olen + j];
        int k = j;
        for (; k < BLOCK_SIZE; k++) {
            if (bt != buf[olen + k]) {
                break;
            }
        }
        if (k == BLOCK_SIZE) {
            if (j == BLOCK_SIZE - bt) {
                olen += j;
                break;
            }
            else if (j == BLOCK_SIZE - 1) {
                olen += BLOCK_SIZE;
                break;
            }
        }
    }
    
    char * odata = (char *)malloc(olen + 1);
    odata[olen] = '\0';
    for (int k = 0; k < olen; k++) {
        odata[k] = buf[k];
    }
    
    *outLength = olen;
    free(buf);
    
    
    return odata;
}

+ (NSString *)encode3Des:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
{
    if ([key1 length] != 8) {
        return input;
    }
    if ([key2 length] != 8) {
        return input;
    }
    if ([key3 length] != 8) {
        return input;
    }
    const char * cText = [input UTF8String];
    const char * cKey1 = [key1 UTF8String];
    const char * cKey2 = [key2 UTF8String];
    const char * cKey3 = [key3 UTF8String];
    //
    if(cText==NULL)
        return @"";
    
    int outLength = [input lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    char* srcbt1 = encryptEncode(cText,cKey1,&outLength);
    if(srcbt1 == NULL)
        return input;
    
    char* srcbt2 = encryptEncode(srcbt1,cKey2,&outLength);
    free((char*)srcbt1);
    if(srcbt2 == NULL)
        return input;
    
    char* srcbt3 = encryptEncode(srcbt2,cKey3,&outLength);
    free((char*)srcbt2);
    if(srcbt3 == NULL)
        return input;
    
    NSData * data = [Base64 Base64EncodeWithChars:srcbt3 length:outLength];
    free(srcbt3);
    
    NSString * strText = [[NSString alloc] initWithBytesNoCopy:(void*)data.bytes length:data.length encoding:NSUTF8StringEncoding freeWhenDone:NO];
    
    return [strText autorelease];
    
}

+ (NSString *)decode3Des:(NSString *)input key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
{
    if ([key1 length] != 8) {
        key1 = @"liluxin1";
    }
    if ([key2 length] != 8) {
        key2 = @"liluxin1";
    }
    if ([key3 length] != 8) {
        key3 = @"liluxin1";
    }
    const char * cText = [input UTF8String];
    const char * cKey1 = [key1 UTF8String];
    const char * cKey2 = [key2 UTF8String];
    const char * cKey3 = [key3 UTF8String];
    if(cText==NULL)
        return @"";
    
    if(strlen(cText) == 0)
        return input;
    
    NSData * data = [Base64 Base64DecodeWithChars:cText];
    cText = data.bytes;
    if(cText == NULL)
        return input;
    
    int outLength = [data length];
    //
    char* srcbt1 = decryptEncode(cText,cKey3,&outLength);
    if(srcbt1 == NULL)
        return input;
    
    char* srcbt2 = decryptEncode(srcbt1,cKey2,&outLength);
    free(srcbt1);
    
    if(srcbt2 == NULL)
        return input;
    
    char* srcbt3 = decryptEncode(srcbt2,cKey1,&outLength);
    free(srcbt2);
    
    if(srcbt3 == NULL)
        return input;
    
    
    srcbt3[outLength] = '\0';
    
    NSString * baseStr = [[NSString alloc] initWithBytesNoCopy:srcbt3 length:outLength encoding:NSUTF8StringEncoding freeWhenDone:YES];
    
    return [baseStr autorelease];
    
}

@end
