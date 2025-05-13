//
//  WKWebView+WYExtension.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/11/27.
//  Copyright © 2018 jacke-xu. All rights reserved.
//

#import "WKWebView+WYExtension.h"
#include <objc/runtime.h>

@interface WYWebViewProgressObserver : NSObject
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation WYWebViewProgressObserver

- (instancetype)initWithWebView:(WKWebView *)webView color:(UIColor *)color {
    if (self = [super init]) {
        _webView = webView;

        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, webView.frame.size.width, 2)];
        _progressView.progressTintColor = color ?: [UIColor colorWithRed:0.4 green:0.8 blue:0.95 alpha:1.0];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [webView addSubview:_progressView];

        [webView addObserver:self forKeyPath:@"estimatedProgress"
                     options:NSKeyValueObservingOptionNew context:nil];

        // 自动布局适配
        _progressView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [_progressView.topAnchor constraintEqualToAnchor:webView.topAnchor],
            [_progressView.leadingAnchor constraintEqualToAnchor:webView.leadingAnchor],
            [_progressView.trailingAnchor constraintEqualToAnchor:webView.trailingAnchor],
            [_progressView.heightAnchor constraintEqualToConstant:2]
        ]];
    }
    return self;
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        _progressView.hidden = progress >= 1.0;
        [_progressView setProgress:progress animated:YES];

        if (progress >= 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressView setProgress:0.0 animated:NO];
            });
        }
    }
}

@end

// MARK: - 分类实现

static const void *WYProgressObserverKey = &WYProgressObserverKey;

@implementation WKWebView (WYProgress)

- (void)wy_startProgressWithColor:(nullable UIColor *)color {
    // 避免重复添加
    if ([self wy_progressObserver]) return;

    WYWebViewProgressObserver *observer = [[WYWebViewProgressObserver alloc] initWithWebView:self color:color];
    objc_setAssociatedObject(self, WYProgressObserverKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wy_stopProgressObserver {
    objc_setAssociatedObject(self, WYProgressObserverKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WYWebViewProgressObserver *)wy_progressObserver {
    return objc_getAssociatedObject(self, WYProgressObserverKey);
}

@end
