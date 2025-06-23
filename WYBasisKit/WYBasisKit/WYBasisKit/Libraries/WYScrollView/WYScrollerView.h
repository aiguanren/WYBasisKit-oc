//
//  WYScrollerView.h
//  WYBasisKit
//
//  Created by jacke-xu on 2017/4/29.
//  Copyright © 2017年 jacke-xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYScrollerView : UIView

/**
 *  设置占位图
 */
@property (nonatomic, strong) UIImage *placeholderImage;


/**
 *  设置分页控件位置，默认为底部中间
 *  只有一张图片时，pageControl隐藏
 */
@property (nonatomic, assign) CGPoint pageControlPoint;


/**
 *  每一页停留时间，默认为3s，最少1s
 *  当设置的值小于1s时，则为默认值
 */
@property (nonatomic, assign) NSTimeInterval standingTime;


/**
 *  是否需要无限轮播，默认关闭
 *  当设置NO时，会关闭定时器
 */
@property (nonatomic, assign) BOOL infiniteShuffling;

/**
 *  单独设置图片
 */
@property (nonatomic, strong) NSArray *images;

/**
 *  设置标签描述
 */
- (void)layoutLabelWithDescribes:(NSArray *)describes Frame:(CGRect)frame;


/*
 *  构造方法
 *
 *  @param  frame  滚动视图控件frame
 *
 *  @param  images 需要滚动的图片数组  可以是UIImage或NSURL
 *
 *  @param  action 图片的点击事件
 */
- (instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images Action:(void(^)(NSInteger index))action;


/*
 *  获取控件的偏移量
 */
- (void)getOffsetAction:(void (^)(CGPoint offset))action;


/**
 *  设置分页控件指示器的图片
 *  两个图片必须同时设置，否则设置无效
 *  不设置则为系统默认
 *
 *  @param image    其他页码的图片
 *  @param currentImage 当前页码的图片
 */
- (void)updatePageControlImage:(UIImage *)image CurrentImage:(UIImage *)currentImage;



/**
 *  设置分页控件指示器的颜色
 *  不设置则为系统默认
 *
 *  @param color    其他页码的颜色
 *  @param currentColor 当前页码的颜色
 */
- (void)updatePageControlColor:(UIColor *)color CurrentPageColor:(UIColor *)currentColor;


/**
 *  开启定时器
 *  默认关闭，调用该方法会开启定时器
 */
- (void)startTimer;


/**
 *  停止定时器
 *  滚动视图将不再自动轮播
 */
- (void)stopTimer;


@end
