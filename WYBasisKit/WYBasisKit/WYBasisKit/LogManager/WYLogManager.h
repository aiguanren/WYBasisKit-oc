//
//  WYLogManager.h
//  WYBasisKit
//
//  Created by guanren on 2025/7/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 日志输出模式
typedef NS_ENUM(NSInteger, WYLogOutputMode) {
    /// 不保存日志，仅在 DEBUG 模式下输出到控制台（默认）
    DebugConsoleOnly = 0,
    
    /// 不保存日志，DEBUG 和 RELEASE 都输出到控制台
    AlwaysConsoleOnly,
    
    /// 保存日志，仅在 DEBUG 模式下输出到控制台
    DebugConsoleAndFile,
    
    /// 保存日志，DEBUG 和 RELEASE 都输出到控制台
    AlwaysConsoleAndFile,
    
    /// 仅保存日志，DEBUG 和 RELEASE 均不输出到控制台
    OnlySaveToFile
};

/// 输出日志（仅输出到控制台）
#define NSLog(format, ...) \
    WYLogManager.output([NSString stringWithFormat:format, ##__VA_ARGS__], \
                        __FILE__, \
                        __FUNCTION__, \
                        __LINE__)

/// 输出日志（自定义日志模式）
#define NSLogWithMode(mode, format, ...) \
    WYLogManager.outputWithMode(mode, \
                               [NSString stringWithFormat:format, ##__VA_ARGS__], \
                               __FILE__, \
                               __FUNCTION__, \
                               __LINE__)

@interface WYLogManager : NSObject

/// 获取日志文件路径（可以通过路径获取并导出或上传）
@property (class, nonatomic, copy, readonly) NSString *logFilePath;

/// 输出日志（仅输出到控制台）
@property (class, nonatomic, copy, readonly) void (^output)(NSString *message, const char *file, const char *function, NSInteger line);

/// 输出日志（自定义日志模式）
@property (class, nonatomic, copy, readonly) void (^outputWithMode)(WYLogOutputMode mode, NSString *message, const char *file, const char *function, NSInteger line);

/// 清除日志文件
@property (class, nonatomic, copy, readonly) void (^clearLogFile)(void);

/// 显示预览组件（默认添加到keyWindow）
+ (void)showPreview;

/**
 * 显示预览组件
 * @param contentView 预览按钮的父控件，(如果不传则为keyWindow，等价于showPreview方法)
 */
+ (void)showPreviewInView:(UIView * _Nullable)contentView;

/// 移除预览组件
+ (void)removePreview;

@end

NS_ASSUME_NONNULL_END
