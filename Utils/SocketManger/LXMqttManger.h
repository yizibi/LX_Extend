//
//  LXMqttManger.h
//  FireControl
//
//  Created by lucy 李 on 2019/1/11.
//  Copyright © 2019年 tpson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LXMqttManger : NSObject

interfaceSingle(LXMqttManger);

- (void)startSubcribeMessageWithDeviceTheme:(NSString *)deviceTheme delegate:(id<MQTTSessionDelegate>)delegate;
- (void)unSubscribeMessageWithDeviceTheme:(NSString *)deviceTheme delegate:(id<MQTTSessionDelegate>)delegate;
- (void)startConnectServer;
- (void)disConnectServer;

@end

