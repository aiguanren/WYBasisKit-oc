//
//  UIApplication+WYExtension.m
//  WYBasisKit
//
//  Created by 官人 on 2025/8/3.
//

#import "UIApplication+WYExtension.h"

@implementation UIApplication (WYExtension)

- (UIWindow *)wy_keyWindow {
    for (UIScene *scene in self.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }
    return [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

@end
