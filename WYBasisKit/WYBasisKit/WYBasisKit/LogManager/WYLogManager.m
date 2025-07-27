//
//  WYLogManager.m
//  WYBasisKit
//
//  Created by guanren on 2025/7/26.
//

#import "WYLogManager.h"
#import <UIKit/UIKit.h>

// 悬浮按钮
@interface WYLogFloatingButton : UIButton
@end

// 日志预览控制器
@interface WYLogPreviewViewController : UIViewController <UISearchBarDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *logs;
@end

// 日志行为封装（用于按钮事件）
@interface WYLogAction : NSObject
+ (void)showLogPreview;
@end

NSString * const WYLogEntrySeparator = @"\n\n\n";
@implementation WYLogManager

/// 悬浮按钮实例
static WYLogFloatingButton *_floatingButton = nil;

/// 获取日志队列（串行队列，保证文件写入线程安全）
+ (dispatch_queue_t)logQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.WYBasisKit.WYLogManager.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

/// 获取当前日志文件路径
+ (NSString *)logFilePath {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    }
    if (!appName) {
        appName = @"App";
    }
    
    // 去除非法字符，防止文件名异常
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9_\\-]" options:0 error:nil];
    NSString *sanitized = [regex stringByReplacingMatchesInString:appName options:0 range:NSMakeRange(0, appName.length) withTemplate:@"_"];
    
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.log", sanitized]];
}

/// 默认输出模式 DebugConsoleOnly，带调用位置信息
+ (void (^)(NSString *, const char *, const char *, NSInteger))output {
    return ^(NSString *msg, const char *file, const char *function, NSInteger line) {
        [self outputMessage:msg file:file function:function line:line mode:DebugConsoleOnly];
    };
}

/// 支持自定义日志输出模式，带调用位置信息
+ (void (^)(WYLogOutputMode, NSString *, const char *, const char *, NSInteger))outputWithMode {
    return ^(WYLogOutputMode mode, NSString *msg, const char *file, const char *function, NSInteger line) {
        [self outputMessage:msg file:file function:function line:line mode:mode];
    };
}

/// 清空日志文件
+ (void (^)(void))clearLogFile {
    return ^{
        [self deleteLogFile];
    };
}

/**
 * 实际日志输出方法，包含时间戳、文件名、方法名、行号信息
 *
 * @param message     日志内容
 * @param file        调用日志的源文件路径
 * @param function    调用日志的方法名
 * @param line        调用日志的行号
 * @param outputMode  日志输出模式（控制台、文件等）
 */
+ (void)outputMessage:(NSString *)message
                 file:(const char *)file
             function:(const char *)function
                 line:(NSInteger)line
                 mode:(WYLogOutputMode)outputMode {
    
    // 安全转换 C 字符串到 NSString
    NSString *fileStr = file ? [NSString stringWithUTF8String:file] : @"UnknownFile";
    NSString *functionStr = function ? [NSString stringWithUTF8String:function] : @"UnknownFunction";
    NSString *fileName = [fileStr lastPathComponent];
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    
    // 格式化输出内容
    NSString *consoleOutput = [NSString stringWithFormat:@"%@ ——> %@ ——> %@ ——> line:%ld\n\n%@%@",
                               timestamp, fileName, functionStr, (long)line, message, WYLogEntrySeparator];
    
    // 按模式选择输出目标
    switch (outputMode) {
        case DebugConsoleOnly:
#if DEBUG
            printf("%s", [consoleOutput UTF8String]);
#endif
            break;
        case AlwaysConsoleOnly:
            printf("%s", [consoleOutput UTF8String]);
            break;
        case DebugConsoleAndFile:
#if DEBUG
            printf("%s", [consoleOutput UTF8String]);
#endif
            [self saveLogToFile:consoleOutput];
            break;
        case AlwaysConsoleAndFile:
            printf("%s", [consoleOutput UTF8String]);
            [self saveLogToFile:consoleOutput];
            break;
        case OnlySaveToFile:
            [self saveLogToFile:consoleOutput];
            break;
    }
}

/// 删除日志文件
+ (void)deleteLogFile {
    dispatch_async([self logQueue], ^{
        NSString *path = [self logFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    });
}

/// 将日志内容写入到文件
+ (void)saveLogToFile:(NSString *)log {
    dispatch_async([self logQueue], ^{
        NSString *path = [self logFilePath];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *dir = [path stringByDeletingLastPathComponent];
        
        // 创建目录和文件（如果不存在）
        if (![fm fileExistsAtPath:dir]) {
            [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![fm fileExistsAtPath:path]) {
            [fm createFileAtPath:path contents:nil attributes:nil];
        }
        
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
        if (!handle) {
            NSLog(@"[WYLogManager] 打开日志文件失败\n");
            return;
        }
        
        @try {
            [handle seekToEndOfFile];
            // 写入 BOM（首次写入时）
            if ([handle offsetInFile] == 0) {
                NSData *bom = [NSData dataWithBytes:"\xEF\xBB\xBF" length:3];
                [handle writeData:bom];
            }
            NSData *data = [log dataUsingEncoding:NSUTF8StringEncoding];
            if (data) {
                [handle writeData:data];
            } else {
                NSLog(@"[WYLogManager] 日志内容无法转换为 UTF-8\n");
            }
        } @finally {
            [handle closeFile];
        }
    });
}

/// 日期和时间信息获取
+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    return formatter;
}

/// 显示预览组件（默认添加到keyWindow）
+ (void)showPreview {
    [self showPreviewInView:nil];
}

/**
 * 显示预览组件
 * @param contentView 预览按钮的父控件，(如果不传则为keyWindow，等价于showPreview方法)
 */
+ (void)showPreviewInView:(UIView *)contentView {
    if (_floatingButton) return;
    
    UIView *targetView = contentView;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    if (!targetView) {
        // 尝试获取任意窗口
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *window in windows) {
            if (window.isKeyWindow) {
                targetView = window;
                break;
            }
        }
        if (!targetView && windows.count > 0) {
            targetView = windows.firstObject;
        }
    }
    if (!targetView) return;
    
    CGRect frame = CGRectMake(targetView.bounds.size.width - 70,
                              targetView.bounds.size.height - 150,
                              50, 50);
    _floatingButton = [[WYLogFloatingButton alloc] initWithFrame:frame];
    [_floatingButton setTitle:@"日志" forState:UIControlStateNormal];
    _floatingButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:0.8];
    _floatingButton.layer.cornerRadius = 25;
    _floatingButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_floatingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _floatingButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    _floatingButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _floatingButton.layer.shadowOpacity = 0.25;
    _floatingButton.layer.shadowRadius = 4;
    _floatingButton.layer.shadowOffset = CGSizeMake(0, 2);
    [_floatingButton addTarget:[WYLogAction class] action:@selector(showLogPreview) forControlEvents:UIControlEventTouchUpInside];
    
    [targetView addSubview:_floatingButton];
}

/// 移除预览组件
+ (void)removePreview {
    if (_floatingButton) {
        [_floatingButton removeFromSuperview];
        _floatingButton = nil;
    }
}

@end

// 悬浮按钮实现
@implementation WYLogFloatingButton {
    CGPoint _startPoint;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    UIView *superview = self.superview;
    if (!superview) return;
    
    CGPoint translation = [gesture translationInView:superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _startPoint = self.center;
    }
    
    CGPoint newCenter = CGPointMake(_startPoint.x + translation.x, _startPoint.y + translation.y);
    
    // 边界判断，防止按钮超出屏幕
    CGFloat halfWidth = CGRectGetWidth(self.bounds) / 2;
    CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2;
    CGFloat superWidth = CGRectGetWidth(superview.bounds);
    CGFloat superHeight = CGRectGetHeight(superview.bounds);
    
    newCenter.x = MAX(halfWidth, MIN(superWidth - halfWidth, newCenter.x));
    newCenter.y = MAX(halfHeight, MIN(superHeight - halfHeight, newCenter.y));
    
    self.center = newCenter;
}

@end

// 日志预览控制器实现
@implementation WYLogPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // 关闭按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose
                                                                                          target:self
                                                                                          action:@selector(close)];
    
    // 清除和分享按钮
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                               target:self
                                                                               action:@selector(clear)];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(share)];
    self.navigationItem.rightBarButtonItems = @[shareItem, clearItem];
    
    // 搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索日志关键字";
    self.navigationItem.titleView = searchBar;
    
    // 文本视图
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.font = [UIFont monospacedSystemFontOfSize:13 weight:UIFontWeightRegular];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_textView];
    
    // 布局约束
    [NSLayoutConstraint activateConstraints:@[
        [_textView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [_textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_textView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [self loadLogs];
}

- (void)loadLogs {
    NSError *error;
    NSString *logContent = [NSString stringWithContentsOfFile:[WYLogManager logFilePath]
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    if (error || !logContent) {
        _logs = @"暂无日志";
    } else {
        _logs = logContent;
    }
    _textView.text = _logs;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clear {
    // 若日志内容本身已经为空或是提示文本，无需重复清除
    if ([_logs isEqualToString:@"暂无日志"] || [_logs isEqualToString:@"日志已清除"] || _logs.length == 0) {
        return;
    }
    WYLogManager.clearLogFile();
    _logs = @"";
    _textView.text = @"日志已清除";
}

- (void)share {
    NSString *logPath = [WYLogManager logFilePath];
    NSURL *url = [NSURL fileURLWithPath:logPath];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

// MARK: - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        _textView.text = _logs;
    } else {
        // 用日志分隔符分割日志块
        NSArray *logChunks = [self.logs componentsSeparatedByString:WYLogEntrySeparator];
        NSMutableArray *matchedChunks = [NSMutableArray array];
        
        // 匹配包含搜索词的完整日志块
        for (NSString *chunk in logChunks) {
            if ([chunk localizedCaseInsensitiveContainsString:searchText]) {
                [matchedChunks addObject:chunk];
            }
        }
        
        if (matchedChunks.count > 0) {
            // 重新组合匹配的日志块
            self.textView.text = [matchedChunks componentsJoinedByString:WYLogEntrySeparator];
        } else {
            self.textView.text = @"未找到匹配的日志内容";
        }
    }
}

@end

// MARK: - 日志行为封装
@implementation WYLogAction

+ (void)showLogPreview {
    WYLogPreviewViewController *vc = [[WYLogPreviewViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:nav animated:YES completion:nil];
}

@end
