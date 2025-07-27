//
//  AppDelegate.m
//  WYBasisKit
//
//  Created by guanren on 2018/5/27.
//  Copyright © 2018年 guanren. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@import WYBasisKit_oc;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    _window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init]];
    
    [[WYEventHandler shared] registerEvent:@"AppEventButtonDidSelected" target:self handler:^(id  _Nullable data) {
        NSLog(@"AppEventButtonDidSelected, data = %@",data);
    }];
    
    [[WYEventHandler shared] registerEvent:@"AppEventButtonRestoreDefault" target:self handler:^(id  _Nullable data) {
        NSLog(@"AppEventButtonRestoreDefault, data = %@",data);
    }];
    
    // 屏蔽控制台约束输出
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
