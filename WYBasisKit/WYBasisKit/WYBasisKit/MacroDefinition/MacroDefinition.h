//
//  MacroDefinition.h
//  WYBasisKit
//
//  Created by jacke－xu on 16/9/4.
//  Copyright © 2016年 jacke-xu. All rights reserved.
//

#import <Availability.h>

#ifdef __OBJC__

#ifndef MacroDefinition_h
#define MacroDefinition_h

///NavBar高度 self.navigationController.navigationBar.frame.size.height
#define wy_navBarHeight     44.0f

///电池条高度
#define wy_statusBarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height

///导航栏高度
#define wy_navViewHeight        (wy_statusBarHeight+wy_navBarHeight)

///tabBar高度
#define wy_tabBarHeight         ((wy_isNeatBang == YES) ? (49.0f+34.0f) : 49.0f)

///tabBar安全区域
#define wy_tabbarSafetyZone         ((wy_isNeatBang == YES) ? 34.0f : 0.0f)

///导航栏安全区域
#define wy_navBarSafetyZone         ((wy_isNeatBang == YES) ? 44.0f : 0.0f)

///屏幕宽
#define wy_screenWidth     ([UIScreen mainScreen].bounds.size.width)

///屏幕高(已减去tabbar安全区域高度)
#define wy_screenHeight    ([UIScreen mainScreen].bounds.size.height-wy_tabbarSafetyZone)

///全屏高
#define wy_fullScreenHeight    [UIScreen mainScreen].bounds.size.height

///屏幕宽度比率
#define wy_screenWidthRatio  (wy_screenWidth / 375.0)

///屏幕高度比率
#define wy_screenHeightRatio  (wy_screenHeight / 667.0)

///屏幕宽度比率转换
#define wy_screenWidthRatioValue(value)  (value*wy_screenWidthRatio)

///屏幕高度比率转换
#define wy_screenHeightRatioValue(value)  (value*wy_screenHeightRatio)

///cell宽
#define wy_cellWidth       (self.bounds.size.width)

///cell高
#define wy_cellHeigth      (self.bounds.size.height)

///keyWindow
#define wy_keywindow          [UIApplication sharedApplication].keyWindow

//颜色方法简写
///颜色随机
#define wy_randomColor        [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0]

///自定义颜色
#define wy_hexColor(color)        [UIColor wy_hexColor:color]

/// 获取RGBA颜色
#define WY_RGBA(r,g,b,a)      [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

/// 获取RGB颜色
#define WY_RGB(r,g,b)         WY_RGBA(r,g,b,1.0f)

///字体方法简写  自定义字体网址：http://iosfonts.com
#define wy_pxFont(font)                 [UIFont systemFontOfSize:font/2]//px字号
#define wy_boldFont(font)               [UIFont boldSystemFontOfSize:font]//粗体
#define wy_fontName(font, fontName)     [UIFont fontWithName:fontName size:font]//自定义


///block self
#define wy_weakSelf(type)      __weak typeof(type) weak##type = type;
#define wy_strongSelf(type)    __strong typeof(type) type = weak##type;

//G－C－D
///在子线程上运行的GCD
#define WY_GCD_SubThread(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

///在主线程上运行的GCD
#define WY_GCD_MainThread(block) dispatch_async(dispatch_get_main_queue(),block)

///只运行一次的GCD
#define WY__GCD_OnceThread(block) static dispatch_once_t onceToken; dispatch_once(&onceToken, block);

///DEBUG打印日志
#ifdef DEBUG
# define NSLog(FORMAT, ...) printf("[%s 行号:%d]:\n%s\n\n\n\n",__FUNCTION__,__LINE__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
# define NSLog(FORMAT, ...)
#endif

///由角度、弧度值转换
#define wy_degreesToRadian(degrees) (M_PI * (degrees) / 180.0)  //角度获取弧度
#define wy_radianToDegrees(radian) (radian*180.0)/(M_PI)  //弧度获取角度

///获取app包路径
#define wy_bundlePath     [[NSBundle mainBundle] bundlePath];

///获取app资源目录路径
#define wy_appResourcePath         [[NSBundle mainBundle] resourcePath];

///获取app包的readme.txt文件
#define wy_readmePath         [[NSBundle mainBundle] pathForResource:@"readme" ofType:@"txt"];

///app名字
#define wy_appName          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

#define wy_appStoreName     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

///应用标识
#define wy_appIdentifier    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];

///应用商店版本号
#define wy_appStoreVersion   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

///应用构建版本号
#define wy_appBuildVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


///获取当前语言
#define wy_currentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

///判断是否是传入的iOS系统版本
#define WY_iOSVersion(number)                [[[UIDevice currentDevice] systemVersion] floatValue] == number

///判断是否是传入的iOS系统版本及以上
#define WY_iOSVersionAbove(number)                [[[UIDevice currentDevice] systemVersion] floatValue] >= number

///判断是否是传入的iOS系统版本及以下
#define WY_iOSVersionBelow(number)                [[[UIDevice currentDevice] systemVersion] floatValue] <= number

///判断是否在传入的iOS系统版本之间
#define WY_iOSVersionAmong(smallVersion,bigVersion)                (([[[UIDevice currentDevice] systemVersion] floatValue] >= smallVersion) && ([[[UIDevice currentDevice] systemVersion] floatValue] <= bigVersion))


///判断是竖屏还是横屏
#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)//竖屏

#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)//横屏

//http://www.xueui.cn/design/142395.html
///判断是设备型号
#define wy_isIPhoneSE     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)

#define wy_isIPhone8     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)

#define wy_isIPhone8Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)

#define wy_isIPhoneXR    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size)) && !wy_isIPad : NO)

#define wy_isIPhoneXS    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)

#define wy_isIPhoneXSMax    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !wy_isIPad : NO)

///判断当前机型是使用2x还是3x图
#define wy_is3x      ([[UIScreen mainScreen] currentMode].size.width/[UIScreen mainScreen].bounds.size.width == 3) ? YES : NO

///是否是齐刘海机型
#define wy_isNeatBang      (wy_isIPhoneXS || wy_isIPhoneXSMax || wy_isIPhoneXR) ? YES : NO

///是否是ipad
#define wy_isIPad      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

///是否是iphone
#define wy_isIPhone    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define wy_isSimulator   (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) ? YES : NO


#endif /* MacroDefinition_h */

#endif /* OBJC */
