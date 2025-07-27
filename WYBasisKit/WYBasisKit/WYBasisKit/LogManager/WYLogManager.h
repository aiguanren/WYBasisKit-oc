//
//  WYLogManager.h
//  WYBasisKit
//
//  Created by guanren on 2025/7/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 日志输出模式
 *
 * 重要提示：
 * 1. 若选择包含文件存储的模式
 *    需要在 Info.plist 中配置以下键值，否则无法直接通过设备“文件”App 查看日志：
 *    <key>UIFileSharingEnabled</key>
 *    <true/>
 *    <key>LSSupportsOpeningDocumentsInPlace</key>
 *    <true/>
 *
 * 2. 若在Info.plist中配置上述键值会导致整个 Documents 目录暴露在”文件“App 中，用户将能直接看到 Documents 下的所有文件（包括敏感数据）
 *
 * 3. 若只需共享日志文件，建议通过预览界面的分享功能导出日志（无需配置 Info.plist，不会暴露 Documents 目录），具体可通过以下方式查看日志：
 *    - 调用 showPreview() 显示悬浮按钮
 *    - 点击按钮进入日志预览界面
 *    - 使用右上角分享功能导出日志文件
 */
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
