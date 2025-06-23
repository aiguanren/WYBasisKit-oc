//
//  UIViewController+WYExtension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/19.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "UIViewController+WYExtension.h"
#import "NSString+WYExtension.h"
#import "MacroDefinition.h"

@implementation UIViewController (WYExtension)

- (UIViewController *)wy_findViewController:(NSString *)className {
    
    if([NSString wy_emptyStr:className].length <= 0) return nil;
    
    Class class = NSClassFromString(className);
    
    if (class == nil) return nil;
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if([controller isKindOfClass:class]) {
            
            return controller;
        }
    }
    return nil;
}

- (void)wy_deleteViewController:(NSString *)className complete:(void (^)(void))complete {
    
    if([NSString wy_emptyStr:className].length <= 0) return;
    
    Class class = NSClassFromString(className);
    
    if (class == nil) return;
    
    __kindof NSMutableArray<UIViewController *> *controllers = [self.navigationController.viewControllers mutableCopy];
    
    for (UIViewController *vc in controllers) {
        
        if ([vc isKindOfClass:class]) {
            
            [controllers removeObject:vc];
            
            self.navigationController.viewControllers = [controllers copy];
            
            if(complete) {
                
                complete();
            }
            
            return;
        }
    }
}

- (void)wy_showViewController:(NSString *)className animated:(BOOL)animated displaMode:(WYDisplaMode)displaMode {
    
    if([NSString wy_emptyStr:className].length <= 0) return;
    
    Class class = NSClassFromString(className);
    
    if (class == nil) return;
    
    UIViewController *viewController = [[class alloc]init];
    
    if(viewController == nil) return;
    
    [self showViewController:viewController animated:animated displaMode:displaMode];
}

- (void)wy_showOnlyViewController:(NSString *)className animated:(BOOL)animated displaMode:(WYDisplaMode)displaMode {
    
    if([NSString wy_emptyStr:className].length <= 0) return;
    
    Class class = NSClassFromString(className);
    
    if (class == nil) return;
    
    wy_weakSelf(self);
    [self wy_deleteViewController:className complete:^{
        
        UIViewController *viewController = [[class alloc]init];
        
        if(viewController == nil) return;
        
        [weakself showViewController:viewController animated:animated displaMode:displaMode];
    }];
}

- (void)wy_gobackViewController:(NSString *)className animated:(BOOL)animated {
    
    if([NSString wy_emptyStr:className].length <= 0) return;
    
    Class class = NSClassFromString(className);
    
    if (class == nil) return;
    
    __kindof NSArray<UIViewController *> *controllers = self.navigationController.viewControllers;
    
    for (UIViewController *vc in controllers) {
        
        if ([vc isKindOfClass:class]) {
            
            if([self wy_viewControllerDisplaMode] == WYDisplaModePush) {
                
                [self.navigationController popToViewController:vc animated:animated];
                
            }else {
                
                UIViewController *presentingController = self.presentingViewController;
                
                while (![presentingController isKindOfClass:[vc class]]) {

                    presentingController = presentingController.presentingViewController;
                }
                [presentingController dismissViewControllerAnimated:animated completion:nil];
            }
            
            return;
        }
    }
}

- (WYDisplaMode)wy_viewControllerDisplaMode {
    
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    WYDisplaMode displaMode = WYDisplaModePush;
    if (viewcontrollers.count > 1) {
        
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
            //push方式
            displaMode = WYDisplaModePush;
        }
    }
    else {
        //present方式
        displaMode = WYDisplaModePresent;
    }
    
    return displaMode;
}

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated displaMode:(WYDisplaMode)displaMode {
    
    if(displaMode == WYDisplaModePush) {
        
        [self.navigationController pushViewController:viewController animated:animated];
        
    }else {
        
        [self presentViewController:viewController animated:animated completion:nil];
    }
}

@end
