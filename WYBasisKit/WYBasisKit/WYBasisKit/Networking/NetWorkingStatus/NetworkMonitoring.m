//
//  NetworkMonitoring.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/25.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "NetworkMonitoring.h"
#import "Reachability.h"
#import <UIKit/UIKit.h>

@interface NetworkMonitoring ()

@property (nonatomic, copy) void(^networkStatusHandler)(WYNetworkStatus networkStatus);

@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, strong) UIAlertController *alertAction;

@end

@implementation NetworkMonitoring

static NetworkMonitoring *_networkMonitoring = nil;
+ (NetworkMonitoring *)sharedNetworkMonitoring {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        _networkMonitoring = [[NetworkMonitoring alloc]init];
    });
    
    return _networkMonitoring;
}

- (WYNetworkStatus)networkStatus {
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    return [self networkWithReachability:reachability];
}

- (WYNetworkStatus)networkWithReachability:(Reachability *)reachability {
    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    switch (internetStatus) {
        case ReachableViaWiFi:
            return NetworkStatusWiFi;
            break;
            
        case ReachableViaWWAN:
            return [self cellularMobileParse];
            break;
            
        case NotReachable:
            return NetworkStatusNotReachable;
            
        default:
            return NetworkStatusUnknown;
            break;
    }
}

- (WYNetworkStatus)cellularMobileParse {
    
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *statusBar = [[[application valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    for (id statusBarType in statusBar) {
        if ([statusBarType isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            switch ([[statusBarType valueForKeyPath:@"dataNetworkType"]intValue]) {
                case 0:
                    return NetworkStatusNotReachable;
                    break;
                case 1:
                    return NetworkStatusWWAN2G;
                    break;
                case 2:
                    return NetworkStatusWWAN3G;
                    break;
                case 3:
                    return NetworkStatusWWAN4G;
                    break;
                case 5:
                    return NetworkStatusWiFi;
                    break;
                default:
                    return NetworkStatusUnknown;
                    break;
            }
        }
    }
    return NetworkStatusUnknown;
}

- (void)startNetworkConnectionListening {
    
    [self restoreDefaultWetworkListeningSettings];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkConnectionChanged) name:kReachabilityChangedNotification object:nil];
    
    if(_reachability == nil) {_reachability = [Reachability reachabilityForInternetConnection];}
    [_reachability startNotifier];
}

- (void)networkConnectionChanged {
    
    [self networkWithReachability:_reachability];
    [self dismissAlertAction];
    [self performSelector:@selector(pushAlertAction) withObject:nil afterDelay:2];
}

- (void)networkConnectionChanged:(void (^)(WYNetworkStatus))networkStatusHandler {
    
    self.networkChangedAlert = NO;
    _networkStatusHandler = networkStatusHandler;
}

- (void)restoreDefaultWetworkListeningSettings {
    
    self.networkChangedAlert = YES;
    self.networkAlertTypes = @[@(NetworkStatusNotReachable),
                               @(NetworkStatusUnknown)];
}

- (void)pushAlertAction {
    
    WYNetworkStatus currentNetworkStatus = [self networkStatus];
    if(_networkStatusHandler) {_networkStatusHandler(currentNetworkStatus);}
    if((self.networkChangedAlert == NO) || (self.networkAlertTypes.count <= 0)) return;
    for (NSNumber *networkStatus in self.networkAlertTypes) {
        
        if(currentNetworkStatus == [networkStatus integerValue]) {
            
            if(_alertAction == nil) {
                
                self.alertAction = [UIAlertController alertControllerWithTitle:@"温馨提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                [_alertAction addAction:action];
            }
            _alertAction.message = [self networkStatusDescription:currentNetworkStatus];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_alertAction animated:YES completion:nil];
            
            break;
        }
    }
}

- (void)dismissAlertAction {
    
    [_alertAction dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)networkStatusDescription:(WYNetworkStatus)currentNetworkStatus {
    
    switch (currentNetworkStatus) {
        case NetworkStatusNotReachable:
            return @"无网络连接";
            break;
            
        case NetworkStatusWWAN2G:
            return @"您正在使用蜂窝移动2G网络连接APP";
            break;
            
        case NetworkStatusWWAN3G:
            return @"您正在使用蜂窝移动3G网络连接APP";
            
        case NetworkStatusWWAN4G:
            return @"您正在使用蜂窝移动4G网络连接APP";
            
        case NetworkStatusWiFi:
            return @"您正在使用WiFi连接APP";
            
        default:
            return @"未知网络连接";
            break;
    }
}

- (void)removeNetworkConnectionListening {
    
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    _reachability = nil;
    _alertAction = nil;
}

@end
