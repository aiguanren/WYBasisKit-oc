//
//  WYPagingView.m
//  WYBasisKit
//
//  Created by jacke-xu on 2019/6/1.
//  Copyright © 2019 jacke-xu. All rights reserved.
//

#import "WYPagingView.h"
#import "UIButton+WYEdgeInsets.h"

#define buttonTagBegin 100
#define badgeTagBegin  1000

@interface WYPagingView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *wy_barScrollView;//buttonTitleScrollView

@property (nonatomic, strong) UIScrollView *wy_controllerScrollView;//控制器scrollView

@property (nonatomic, strong) UIView *wy_barScrollLine;//滚动线条

@property (nonatomic, strong) UIButton *wy_currentButtonItem;//当前选中的buttonTitle

@property (nonatomic, strong) NSArray *wy_titleAry;//title数组

@property (nonatomic, strong) NSArray *wy_defaultImageAry;//未选中状态图片数组

@property (nonatomic, strong) NSArray *wy_selerctedImageAry;//选中状态图片数组

@property (nonatomic, strong) NSArray *wy_controllerAry;//控制器数组

@property (nonatomic, weak) UIViewController *wy_superViewController;//父控制器

@property (nonatomic, strong) UIFont *wy_useFont;//计算宽度时使用的字号

@property (nonatomic, copy) void(^wy_scrollAction)(NSInteger pagingIndex);//点击事件block

@end

@implementation WYPagingView

- (instancetype)wy_initWithFrame:(CGRect)frame superViewController:(UIViewController *)superViewController {
    
    if(self == [super initWithFrame:frame]) {
        
        self.frame = frame;
        self.wy_superViewController = superViewController;
        [self wy_setUpDefaultProperty];
        if (@available(iOS 11.0, *)){//避免滚动视图顶部出现20的空白以及push或者pop的时候页面有一个上移或者下移的异常动画的问题
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }
    return self;
}

- (void)wy_setUpDefaultProperty {
    
    _bar_Height = 45;
    
    _bar_originlLeftSpace = 0;
    
    _bar_originlRightSpace = 0;
    
    _bar_dividingSpace = 20;
    
    _barButton_dividingSpace = 5;
    
    _bar_bg_defaultColor = [UIColor whiteColor];
    
    _bar_bg_selectedColor = [UIColor whiteColor];
    
    _bar_title_defaultColor = [UIColor wy_hexColor:@"#7B809E"];
    
    _bar_title_selectedColor = [UIColor wy_hexColor:@"#2D3952"];
    
    _bar_dividingStripColor = [UIColor wy_hexColor:@"#F2F2F2"];
    
    _bar_scrollLineColor = [UIColor wy_hexColor:@"#2D3952"];
    
    _bar_scrollLineWidth = 25;
    
    _bar_scrollLineTop = _bar_Height-5;
    
    _bar_dividingStripHeight = 2;
    
    _bar_scrollLineHeight = 2;
    
    _bar_title_defaultFont = [UIFont systemFontOfSize:14];
    
    _bar_title_selectedFont = [UIFont boldSystemFontOfSize:20];
    
    _wy_useFont = (_bar_title_selectedFont.pointSize > _bar_title_defaultFont.pointSize) ? _bar_title_selectedFont : _bar_title_defaultFont;
    
    _bar_selectedIndex = 0;
    
    _bar_badgeValueFillColor = [UIColor redColor];
    
    _bar_badgeValueTextColor = [UIColor whiteColor];
    
    _bar_badgeValueInsets = UIEdgeInsetsZero;
    
    _bar_badgeValueTextFont = [UIFont systemFontOfSize:9];
    
    _bar_badgeValueOffset = CGPointZero;
}

- (void)setBar_Height:(CGFloat)bar_Height {
    
    _bar_Height = bar_Height;
    _bar_scrollLineTop = _bar_Height-5;
}

- (void)setBar_selectedIndex:(NSInteger)bar_selectedIndex  {
    
    if(bar_selectedIndex > (_wy_titleAry.count-1)) {bar_selectedIndex = 0;}
    
    _bar_selectedIndex = bar_selectedIndex;
    
    UIButton *sender = [(UIButton *)self viewWithTag:buttonTagBegin+_bar_selectedIndex];
    
    if(sender == nil) return;
    
    [self buttonItemClick:sender];
}

- (void)wy_updateDefaultProperty {
    
    if(_bar_selectedIndex > (_wy_titleAry.count-1)) {_bar_selectedIndex = 0;}
    
    if(_wy_titleAry.count <= 1) {
        
        _bar_Width = (_bar_Width > 0) ? _bar_Width : self.frame.size.width-_bar_originlLeftSpace-_bar_originlRightSpace;
        _bar_dividingSpace = 0;
        
        return;
    }
    
    //标题文本总宽度
    CGFloat titleWidth = 0;
    //左右分页栏总间距
    CGFloat totalDividingSpace = 0;
    //两侧原点间距之和
    CGFloat totalOriginlSpace = _bar_originlLeftSpace+_bar_originlRightSpace;
    //左右间隔区间的个数
    NSInteger totalDividingSpaceCount = 0;
    //默认左右分页栏之间的间距
    CGFloat default_dividingSpace = _bar_dividingSpace;
    for (int i=0; i<_wy_titleAry.count; i++) {
        
        titleWidth = (_bar_Width > 0) ? (titleWidth+_bar_Width) : (titleWidth+[_wy_titleAry[i] wy_boundingRectWithSize:CGSizeMake(MAXFLOAT, _bar_Height-_bar_dividingStripHeight) withFont:_wy_useFont lineSpacing:0].width);
        
        if((titleWidth+totalOriginlSpace+(default_dividingSpace*i)) > self.frame.size.width) {
            _bar_dividingSpace = default_dividingSpace;
            return;
        }
        totalDividingSpaceCount = (_wy_titleAry.count-1);
        totalDividingSpace = default_dividingSpace*totalDividingSpaceCount;
        
        if((titleWidth+totalDividingSpace+totalOriginlSpace) < self.frame.size.width) {
            
            _bar_dividingSpace = (self.frame.size.width-titleWidth-totalOriginlSpace)/totalDividingSpaceCount;
        }
        
    }
}

- (void)wy_layoutPagingControllerAry:(NSArray<UIViewController *> *)controllerAry
                            titleAry:(NSArray<NSString *> *)titleAry {
    
    _wy_titleAry = titleAry;
    _wy_controllerAry = controllerAry;
    
    [self wy_updateDefaultProperty];
    
    [self wy_layoutPagingView];
}

- (void)wy_layoutPagingControllerAry:(NSArray<UIViewController *> *)controllerAry
                            titleAry:(NSArray<NSString *> *)titleAry
                     defaultImageAry:(NSArray *)defaultImageAry
                    selectedImageAry:(NSArray *)selectedImageAry {
    
    _wy_titleAry = titleAry;
    _wy_defaultImageAry = defaultImageAry;
    _wy_selerctedImageAry = selectedImageAry;
    _wy_controllerAry = controllerAry;
    
    [self wy_updateDefaultProperty];
    
    [self wy_layoutPagingView];
}

- (void)wy_layoutPagingView {
    
    [self wy_layoutTitleView];
    self.wy_controllerScrollView.backgroundColor = [UIColor whiteColor];
}

- (void)wy_layoutTitleView {
    
    self.wy_barScrollView.backgroundColor = [UIColor whiteColor];
    
    CGFloat leftx = _bar_originlLeftSpace;
    for (int i=0; i<_wy_titleAry.count; i++) {
        
        UIFont *titleFont = _wy_useFont;
        CGFloat titleStrWidth = (_bar_Width > 0) ? _bar_Width : ([_wy_titleAry[i] wy_boundingRectWithSize:CGSizeMake(MAXFLOAT, titleFont.lineHeight) withFont:titleFont lineSpacing:0].width);
        
        UIButton *buttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        buttonItem.frame = CGRectMake(leftx, 0, titleStrWidth, _bar_Height-_bar_dividingStripHeight);
        buttonItem.backgroundColor = (i == _bar_selectedIndex) ? _bar_bg_selectedColor : _bar_bg_defaultColor;
        [buttonItem setTitleColor:_bar_title_defaultColor forState:UIControlStateNormal];
        [buttonItem setTitleColor:_bar_title_selectedColor forState:UIControlStateSelected];
        buttonItem.titleLabel.font = (i == _bar_selectedIndex) ? _bar_title_selectedFont : _bar_title_defaultFont;
        [buttonItem setTitle:_wy_titleAry[i] forState:UIControlStateNormal];
        if((_wy_defaultImageAry.count == _wy_titleAry.count) && (_wy_selerctedImageAry.count == _wy_titleAry.count)) {
            
            UIImage *normalImage = ([_wy_defaultImageAry[i] isKindOfClass:[UIImage class]]) ? _wy_defaultImageAry[i] : [UIImage imageNamed:_wy_defaultImageAry[i]];
            [buttonItem setImage:normalImage forState:UIControlStateNormal];
            
            UIImage *selectedImage = ([_wy_selerctedImageAry[i] isKindOfClass:[UIImage class]]) ? _wy_selerctedImageAry[i] : [UIImage imageNamed:_wy_selerctedImageAry[i]];
            [buttonItem setImage:selectedImage forState:UIControlStateSelected];
            
            [buttonItem wy_layouEdgeInsetsPosition:WYButtonPositionImageTop_titleBottom spacing:_barButton_dividingSpace];
            buttonItem.imageView.contentMode = UIViewContentModeCenter;
        }
        buttonItem.tag = buttonTagBegin+i;
        [buttonItem addTarget:self action:@selector(buttonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i == _bar_selectedIndex) {
            
            buttonItem.selected = YES;
            _wy_currentButtonItem = buttonItem;
        }
        [_wy_barScrollView insertSubview:buttonItem atIndex:0];
        
        leftx += (titleStrWidth+_bar_dividingSpace);
        
        //设置scrollView的ContentSize让其滚动
        if(i == (_wy_titleAry.count-1)) {
            
            _wy_barScrollView.contentSize = CGSizeMake(buttonItem.wy_right+_bar_originlRightSpace, 0);
            
            UIView *dividingView = [[UIView alloc]initWithFrame:CGRectMake(0, _bar_Height-_bar_dividingStripHeight, _wy_barScrollView.contentSize.width, _bar_dividingStripHeight)];
            dividingView.backgroundColor = _bar_dividingStripColor;
            [_wy_barScrollView addSubview:dividingView];
            
            [self lastMethod];
        }
    }
}

- (void)wy_showBadge:(BOOL)show value:(id)value atIndex:(NSInteger)index {
    
    UILabel *badgeView = [self viewWithTag:badgeTagBegin+index];
    UIButton *button = [self viewWithTag:buttonTagBegin+index];
    
    if(button == nil) return;
    
    if(badgeView == nil) {
        
        badgeView = [[UILabel alloc]init];
        badgeView.textColor = _bar_badgeValueTextColor;
        badgeView.font = _bar_badgeValueTextFont;
        badgeView.backgroundColor = _bar_badgeValueFillColor;
        badgeView.wy_textInsets = _bar_badgeValueInsets;
        badgeView.textAlignment = NSTextAlignmentCenter;
        badgeView.clipsToBounds = YES;
        badgeView.tag = badgeTagBegin+index;
        [button.superview addSubview:badgeView];
    }
    badgeView.hidden = !show;
    
    CGSize badgeSize = CGSizeZero;
    if([value isKindOfClass:[UIImage class]]) {
        
        UIImage *patternImage = (UIImage *)value;
        [badgeView setBackgroundColor:[UIColor colorWithPatternImage:patternImage]];
        badgeSize = CGSizeMake(patternImage.wy_width, patternImage.wy_height);
        
    }else {
        
        badgeView.text = (NSString *)value;
        CGSize badgeStrSize = [badgeView.text wy_boundingRectWithSize:CGSizeMake(MAXFLOAT, badgeView.font.lineHeight) withFont:badgeView.font lineSpacing:0];
        badgeStrSize = CGSizeMake(badgeStrSize.width+_bar_badgeValueInsets.left+_bar_badgeValueInsets.right, badgeStrSize.height+_bar_badgeValueInsets.top+_bar_badgeValueInsets.bottom);
        CGFloat badgeStrWidth = (badgeStrSize.width<badgeStrSize.height) ? badgeStrSize.height : badgeStrSize.width;
        badgeSize = CGSizeMake(badgeStrWidth, badgeStrSize.height);
        if([NSString wy_isEmptyStr:badgeView.text] == YES) {
            
            badgeSize = CGSizeMake(_bar_badgeValueInsets.left+_bar_badgeValueInsets.right, _bar_badgeValueInsets.top+_bar_badgeValueInsets.bottom);
        }
        badgeView.layer.cornerRadius = badgeSize.height/2;
    }
    CGFloat buttonStrWidth = [button.currentTitle wy_boundingRectWithSize:CGSizeMake(MAXFLOAT, button.wy_height) withFont:button.titleLabel.font lineSpacing:0].width;
    CGFloat badgeLeft = (button.wy_right-((button.wy_width-buttonStrWidth)/2))+_bar_badgeValueOffset.x;
    CGFloat badgeTop = (button.wy_top+((button.wy_height-button.titleLabel.font.lineHeight)/2))-(badgeSize.height/2);
    
    badgeView.frame = CGRectMake(badgeLeft, badgeTop, badgeSize.width, badgeSize.height);
}

- (void)wy_scrollPagingToIndex:(void (^)(NSInteger))scrollAction {
    
    _wy_scrollAction = scrollAction;
}

- (void)buttonItemClick:(UIButton *)sender {
    
    if(sender.tag != _wy_currentButtonItem.tag) {
        
        _wy_controllerScrollView.contentOffset = CGPointMake(self.frame.size.width*(sender.tag-buttonTagBegin), 0);
    }
    _bar_selectedIndex = sender.tag - buttonTagBegin;
    //重新赋值标签属性
    [self updateItemProperty:sender];
}

- (void)updateItemProperty:(UIButton *)currentItem {
    
    if(currentItem.tag != _wy_currentButtonItem.tag) {
        
        _wy_currentButtonItem.selected = NO;
        
        _wy_currentButtonItem.backgroundColor = _bar_bg_defaultColor;
        [_wy_currentButtonItem setTitleColor:_bar_title_defaultColor forState:UIControlStateNormal];
        _wy_currentButtonItem.titleLabel.font = _bar_title_defaultFont;
        [self updateButtonContentMode];
        
        //将当前选中的item赋值
        currentItem.selected = YES;
        _wy_currentButtonItem = currentItem;
        
        _wy_currentButtonItem.backgroundColor = _bar_bg_selectedColor;
        [_wy_currentButtonItem setTitleColor:_bar_title_selectedColor forState:UIControlStateSelected];;
        _wy_currentButtonItem.titleLabel.font = _bar_title_selectedFont;
        [self updateButtonContentMode];
        
        //调用最终的方法
        [self lastMethod];
    }
}

- (void)updateButtonContentMode {
    
    if((_wy_defaultImageAry.count == _wy_titleAry.count) && (_wy_selerctedImageAry.count == _wy_titleAry.count)) {
        
        [_wy_currentButtonItem wy_layouEdgeInsetsPosition:WYButtonPositionImageTop_titleBottom spacing:_barButton_dividingSpace];
    }
}

- (void)lastMethod{
    
    //计算应该滚动多少
    CGFloat needScrollOffsetX = _wy_currentButtonItem.center.x - _wy_barScrollView.bounds.size.width * 0.5;
    
    //最大允许滚动的距离
    CGFloat maxAllowScrollOffsetX = _wy_barScrollView.contentSize.width - _wy_barScrollView.bounds.size.width;
    
    if (needScrollOffsetX < 0) {
        
        needScrollOffsetX = 0;
    }
    
    if (needScrollOffsetX > maxAllowScrollOffsetX) {
        
        needScrollOffsetX = maxAllowScrollOffsetX;
    }
    
    [_wy_barScrollView setContentOffset:CGPointMake(needScrollOffsetX, 0) animated:YES];
    
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.2f animations:^{
        
        weakself.wy_barScrollLine.frame = CGRectMake(weakself.wy_currentButtonItem.wy_centerx-weakself.bar_scrollLineWidth*0.5, weakself.bar_scrollLineTop, weakself.bar_scrollLineWidth, weakself.bar_scrollLineHeight);
    }];
    
    if(_wy_scrollAction) {
        
        _wy_scrollAction(_wy_currentButtonItem.tag-buttonTagBegin);
    }
}

// 监听滚动事件判断当前拖动到哪一个了
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if((scrollView == _wy_controllerScrollView) && (_wy_controllerScrollView.contentOffset.x >= 0)) {

        CGFloat index = roundf(scrollView.contentOffset.x / self.frame.size.width);
        NSInteger tag = buttonTagBegin+[[NSString stringWithFormat:@"%f",index] integerValue];
        UIButton *channeItem =  (UIButton *)[_wy_barScrollView viewWithTag:tag];
        //重新赋值标签属性
        [self updateItemProperty:channeItem];
    }
}

- (UIScrollView *)wy_barScrollView {
    
    if(_wy_barScrollView == nil) {
        
        UIScrollView *barScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, _bar_Height)];
        barScroll.showsHorizontalScrollIndicator = NO;
        
        UIView *scrollLine = [[UIView alloc]initWithFrame:CGRectMake(0, _bar_scrollLineTop, _bar_scrollLineWidth, _bar_scrollLineHeight)];
        scrollLine.backgroundColor = _wy_titleAry.count > 1 ? _bar_scrollLineColor : [UIColor clearColor];
        
        [barScroll addSubview:scrollLine];
        [self addSubview:barScroll];
        
        _wy_barScrollLine = scrollLine;
        _wy_barScrollView = barScroll;
    }
    return _wy_barScrollView;
}

- (UIScrollView *)wy_controllerScrollView {
    
    if(_wy_controllerScrollView == nil) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _bar_Height, self.frame.size.width, self.frame.size.height-_bar_Height)];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.scrollEnabled = YES;
        scrollView.contentSize = CGSizeMake(self.frame.size.width*_wy_titleAry.count, scrollView.frame.size.height);
        [scrollView setContentOffset:CGPointMake(self.frame.size.width*_bar_selectedIndex, 0)];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        _wy_controllerScrollView = scrollView;
        
        for (int i = 0; i < _wy_controllerAry.count; i++) {
            
            UIViewController *viewcontroller = _wy_controllerAry[i];
            UIView *vcview = viewcontroller.view;
            vcview.frame = CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, scrollView.frame.size.height);
            
            [scrollView addSubview:vcview];
            [self.wy_superViewController addChildViewController:viewcontroller];
        }
    }
    return _wy_controllerScrollView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
