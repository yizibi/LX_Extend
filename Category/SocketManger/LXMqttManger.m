//
//  LXMqttManger.m
//  FireControl
//
//  Created by lucy 李 on 2019/1/11.
//  Copyright © 2019年 tpson. All rights reserved.
//

#import "LXMqttManger.h"
#import <MQTTClient.h>
#import <MQTTWebsocketTransport.h>


@interface LXMqttManger()<MQTTSessionDelegate>

@property (nonatomic, strong) MQTTSession *session;

@end

@implementation LXMqttManger

implementationSingle(LXMqttManger);
- (void)startConnectServer {
    [self activeNotification:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)receiveMQTTServicerMessage {
    //    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    //    transport.host = kUserInfo.user.mqttInfo.server;
    MQTTWebsocketTransport *transport = [[MQTTWebsocketTransport alloc] init];
    transport.url = [NSURL URLWithString:kUserInfo.user.mqttInfo.server];
    //    transport.port = 1883;
    MQTTSession *session = [[MQTTSession alloc] init];
    session.clientId = kUserInfo.user.mqttInfo.clientId;
    session.transport = transport;
    session.delegate = self;
    session.userName = kUserInfo.user.mqttInfo.username;
    session.password = kUserInfo.user.mqttInfo.password;
    session.cleanSessionFlag = YES;
    session.willQoS = MQTTQosLevelAtMostOnce;
    self.session = session;
    //    [session connectAndWaitTimeout:1];
    [session addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld) context:nil];
    [session connectWithConnectHandler:^(NSError *error) {
        DebugLog(@"错误的信息:%@",error);
        if (error) return;
        DebugLog(@"MQTT链接成功了");
        //订阅报警数据
        [self startSubcribeMessageWithDeviceTheme:[NSString stringWithFormat:@"/notification/public/user/%@",kUserInfo.user.mqttInfo.clientId] delegate:self];
    }];
}
#pragma mark - 系统的通知监听
- (void)activeNotification:(NSNotification *)notification {
    if (_session == nil) {
        //MQTT推送报警
        [self receiveMQTTServicerMessage];
    }
}
- (void)backgroundNotification:(NSNotification *)notification{
    [self disConnectServer];
}

- (void)disConnectServer {
    //取消报警订阅
    [self unSubscribeMessageWithDeviceTheme:[NSString stringWithFormat:@"/notification/public/user/%@",kUserInfo.user.mqttInfo.clientId] delegate:self];
    self.session.delegate = nil;
    [self.session disconnect];
    self.session = nil;
}
- (void)startSubcribeMessageWithDeviceTheme:(NSString *)deviceTheme delegate:(id<MQTTSessionDelegate>)delegate {
    self.session.delegate = delegate;
    if (self.session.status == MQTTSessionStatusConnected) {
        //订阅
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.session subscribeToTopic:deviceTheme atLevel:MQTTQosLevelAtMostOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
                    if (error) {
                        NSLog(@"订阅失败: %@", error.localizedDescription);
                    }
                    else {
                        NSLog(@"订阅成功: %@", gQoss);
                    }
                }];
            });
        });
    }
}
- (void)unSubscribeMessageWithDeviceTheme:(NSString *)deviceTheme delegate:(id<MQTTSessionDelegate>)delegate {
    if (self.session.status == MQTTSessionStatusConnected) {
        //取消订阅
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.session unsubscribeTopic:deviceTheme unsubscribeHandler:^(NSError *error) {
                    if (error) {
                        NSLog(@"取消订阅失败: %@", error.localizedDescription);
                    }
                    else {
                        NSLog(@"取消订阅成功:");
                        
                    }
                }];
            });
        });
    }
}
#pragma mark - MQTTSessionDelegate
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    kweakSelf;
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    DebugLog(@"主题信息:%@ \n,收到的信息:%@",topic,dic);
   
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    DebugLog(@"MQTT的状态:%@_____%@",self.session,change);
    if (self.session.status == 4) {
        [self.session connect];
    }
}
//json格式字符串转字典：
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}

@end
