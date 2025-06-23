//
//  UIAlertController+WYExtension.h
//  WYBasisKit
//
//  Created by bangtuike on 2019/6/28.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (WYExtension)

/// 点击空白处关闭弹窗
- (void)wy_clickBlankCloseAlert:(void(^__nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
