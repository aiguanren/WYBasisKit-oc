//
//  StateView.m
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/8/16.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import "StateView.h"
#import "NSString+WYExtension.h"
#import "UIView+WYExtension.h"
#import "MacroDefinition.h"
#import "UILabel+WYExtension.h"

@interface StateView ()

///显示图标
@property (nonatomic, weak) UIImageView *imageView;

///显示文本
@property (nonatomic, weak) UILabel *label;

///弹窗延时时间
@property (nonatomic, assign) CGFloat delayed;

///记录延时状态(每次按照自定义延时时间延时还是单次按照自定义延时时间延时)
@property (nonatomic, assign) BOOL eachDelay;

///记录是否需要自动移除弹窗
@property (nonatomic, assign) BOOL autoRemove;

///记录用户交互状态
@property (nonatomic, assign) BOOL userEnabled;

@end

@implementation StateView

static StateView *_stateView = nil;

#pragma mark 构造单例
+ (StateView *)shared {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        _stateView = [[StateView alloc]initWithFrame:CGRectZero];
        _stateView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _stateView.layer.cornerRadius = 15;
        _stateView.layer.masksToBounds = YES;
        _stateView.delayed = 1.5f;
        _stateView.autoRemove = YES;
        _stateView.userEnabled = YES;
    });
    
    _stateView.alpha = 1.0f;
    
    return _stateView;
}

#pragma mark 构造方法
+ (void)showSuccessInfo:(NSString *)info {
    
    [self layoutStateViewWithImage:@"success" info:[NSString wy_emptyStr:info]];
}

+ (void)showErrorInfo:(NSString *)info {
    
    [self layoutStateViewWithImage:@"error" info:[NSString wy_emptyStr:info]];
}

+ (void)showWarningInfo:(NSString *)info {
    
    [self layoutStateViewWithImage:@"warning" info:[NSString wy_emptyStr:info]];
}

+ (void)userInteractionEnabled:(BOOL)userInteractionEnabled {
    
    //设置用户交互
    [self shared].userEnabled = userInteractionEnabled;
    _stateView.superview.userInteractionEnabled = userInteractionEnabled;
}

+ (void)windowDelayed:(CGFloat)delayed eachDelay:(BOOL)eachDelay {
    
    [self shared].delayed = delayed;
    [self shared].eachDelay = eachDelay;
}

+ (void)automaticRemoveWindow:(BOOL)autoRemove {
    
    [self shared].autoRemove = autoRemove;
}

+ (void)layoutStateViewWithImage:(NSString *)image info:(NSString *)info {
    
    //获取单例
    _stateView = [self shared];
    
    //设置并加载在俯视图上
    [self initializationSettings:image info:info];
}

+ (void)dismiss {
    
    //重置延时策略
    if(_stateView.eachDelay == NO) {_stateView.delayed = 1.5f;}
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //加个渐隐动画
        _stateView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        //移除自己
        [_stateView removeFromSuperview];
        
        //打开用户交互
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }];
}

#pragma mark 初始化设置
+ (void)initializationSettings:(NSString *)image info:(NSString *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _stateView.imageView.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] pathForResource:@"Loading" ofType:@"bundle"] stringByAppendingPathComponent:image]];
        
        _stateView.label.text = info;
        _stateView.label.hidden = !(info.length > 0);
        
        //给定临时宽度
        CGFloat tempWidth = (_stateView.label.hidden == YES) ? _stateView.imageView.wy_width+(_stateView.imageView.wy_top*2) : wy_screenWidth*0.25;
        
        if(_stateView.label.hidden == NO) {
            
            //根据文本及计算弹窗width
            tempWidth = [self sharedWindowWidth:tempWidth];
        }
        
        _stateView.wy_size = CGSizeMake(tempWidth, (_stateView.label.hidden == YES) ? tempWidth : _stateView.label.wy_bottom+10);

        _stateView.imageView.wy_left = (_stateView.wy_width-_stateView.imageView.wy_width)/2;

        _stateView.center = [UIApplication sharedApplication].keyWindow.center;
        
        //添加到父控制器上
        [[UIApplication sharedApplication].keyWindow addSubview:_stateView];
        
        //设置用户交互
        _stateView.superview.userInteractionEnabled = _stateView.userEnabled;
        
        if(_stateView.autoRemove == NO) return;
        
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:_stateView.delayed];
    });
}

//布局关键
+ (CGFloat)sharedWindowWidth:(CGFloat)tempWidth {
    
    //临时宽度
    CGFloat windowWidth = tempWidth;
    //label的左间距
    CGFloat labelLeft = _stateView.label.wy_left;
    //label最低width
    CGFloat labelWidth = windowWidth-(labelLeft*2);
    //文本总宽度
    CGFloat textWidth = [_stateView.label.text wy_boundingRectWithSize:CGSizeMake(MAXFLOAT, _stateView.label.font.lineHeight) withFont:_stateView.label.font lineSpacing:0].width;
    //最大支持屏幕的0.45倍宽,否则就不好看了
    CGFloat maxWidth = wy_screenWidth*0.45;

    //需要折行计算
    if(textWidth > labelWidth) {
        
        if (textWidth < (labelWidth+_stateView.label.font.lineHeight)) {
            
            windowWidth = textWidth+(labelLeft*2);
        }
        else {
            
            windowWidth = windowWidth+_stateView.label.font.lineHeight*2;
            //计算lable的显示行数
            CGFloat showLine = [_stateView.label.text wy_textShowLinesWithControlWidth:windowWidth - (labelLeft*2) font:_stateView.label.font lineSpacing:0].count;
            if(showLine > 3) {
                
                windowWidth = windowWidth+_stateView.label.font.lineHeight*3;
            }
        }
        if(windowWidth >= maxWidth) {windowWidth = maxWidth;}
    }

    _stateView.label.wy_width = windowWidth-(labelLeft*2);
    //这里执行下sizeToFit，防止弹窗底部留白过大
    [_stateView.label sizeToFit];
    //重置lable.size，防止原点改变
    _stateView.label.wy_size = CGSizeMake(windowWidth-(labelLeft*2), _stateView.label.wy_height);
    
    return windowWidth;
}

#pragma mark 懒加载
- (UIImageView *)imageView {
    
    if(_imageView == nil) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.wy_top = 20;
        imgView.wy_size = CGSizeMake(35, 35);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_stateView addSubview:imgView];
        
        _imageView = imgView;
    }
    
    return _imageView;
}

- (UILabel *)label {
    
    if(_label == nil) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
        lab.wy_top = 65;
        lab.wy_left = 5+_stateView.layer.cornerRadius;
        lab.font = [UIFont boldSystemFontOfSize:16];
        lab.numberOfLines = 4;
        [lab wy_centerAlign];
        lab.textColor = [UIColor whiteColor];
        
        [_stateView addSubview:lab];
        
        _label = lab;
    }
    
    return _label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
