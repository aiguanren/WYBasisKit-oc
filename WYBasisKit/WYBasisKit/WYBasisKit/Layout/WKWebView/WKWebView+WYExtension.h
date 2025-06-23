//
//  WKWebView+WYExtension.h
//  WYBasisKit
//
//  Created by  guanren on 2018/11/27.
//  Copyright © 2018 guanren. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (WYExtension)


/// 显示进度条（可自定义颜色）
- (void)wy_startProgressWithColor:(nullable UIColor *)color;

/// 停止进度条监听（需在 dealloc 时调用）
- (void)wy_stopProgressObserver;

@end

NS_ASSUME_NONNULL_END
