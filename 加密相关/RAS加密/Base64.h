

#import <Foundation/Foundation.h>


@interface Base64 : NSObject {
	
}

+ (NSData *)Base64EncodeWithChars:(const char*)lpszSrc  length:(int)length;
+ (NSData *)Base64DecodeWithChars:(const char*)lpszSrc;

@end

