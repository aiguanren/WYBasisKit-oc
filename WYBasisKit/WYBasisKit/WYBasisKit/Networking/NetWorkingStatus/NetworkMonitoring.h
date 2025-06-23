//
//  NetworkMonitoring.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/25.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    /** 无网络连接 */
    NetworkStatusNotReachable = 0,
    /** 未知网络连接 */
    NetworkStatusUnknown,
    /** 2G网络 */
    NetworkStatusWWAN2G,
    /** 3G网络 */
    NetworkStatusWWAN3G,
    /** 4G网络 */
    NetworkStatusWWAN4G,
    /** WiFi网络 */
    NetworkStatusWiFi
} WYNetworkStatus;

@interface NetworkMonitoring : NSObject

/** 网络监控单例 */
+ (NetworkMonitoring *)sharedNetworkMonitoring;

/** 当前网络状态 */
@property (nonatomic, readonly, assign) WYNetworkStatus networkStatus;

/** 网络状态改变后是否需要弹窗警告 调用startNetworkConnectionListening方法后生效 默认YES */
@property (nonatomic, assign) BOOL networkChangedAlert;

/** 网络状态改变后需要弹窗警告的类型 调用startNetworkConnectionListening方法后生效 默认@[@(NetworkStatusNotReachable),@(NetworkStatusUnknown)] */
@property (nonatomic, strong) NSArray *networkAlertTypes;

/** 开始网络连接监听,内部会调用restoreDefaultWetworkListeningSettings */
- (void)startNetworkConnectionListening;

/** 网络连接状态改变后的block事件,调用后将设置networkChangedAlert为NO */
- (void)networkConnectionChanged:(void(^)(WYNetworkStatus networkStatus))networkStatusHandler;

/** 恢复默认网络监听设置 将重置networkChangedAlert与networkAlertTypes为初始设置 */
- (void)restoreDefaultWetworkListeningSettings;

/** 移除网络连接监听 */
- (void)removeNetworkConnectionListening;

@end
