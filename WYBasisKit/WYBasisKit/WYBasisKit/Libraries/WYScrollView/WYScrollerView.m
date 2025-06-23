//
//  WYScrollerView.m
//  WYBasisKit
//
//  Created by jacke-xu on 2017/4/29.
//  Copyright © 2017年 jacke-xu. All rights reserved.
//

#import "WYScrollerView.h"
#import "UIImageView+WebCache.h"
#import "MacroDefinition.h"

@interface WYScrollerViewCell : UICollectionViewCell

//占位图
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *lab;

//更新轮播图片
- (void)updateCollectionViewCellImage:(id)image describe:(NSString *)describe describeFrame:(CGRect)describeFrame;

@end

@implementation WYScrollerViewCell

- (void)updateCollectionViewCellImage:(id)image describe:(NSString *)describe describeFrame:(CGRect)describeFrame {
    
    if ([image isKindOfClass:[NSString class]]) { //网络图片
        
        [self.imageView sd_setImageWithURL:image placeholderImage:_placeholderImage];
        
    } else {//直接就是图片
        
        self.imageView.image = image;
    }
    
    if(describe.length > 0) {
        
        self.lab.frame = describeFrame;
        _lab.text = describe;
    }
}

- (UIImageView *)imageView {
    
    if(!_imageView) {
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        imageview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imageview];
        _imageView = imageview;
    }
    
    return _imageView;
}

- (UILabel *)lab {
    
    if(!_lab) {
        
        UILabel *lable = [[UILabel alloc]init];
        lable.textColor = WY_RGB(153, 153, 153);
        lable.font = [UIFont systemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lable];
        
        _lab = lable;
    }
    
    return _lab;
}

@end

@interface WYScrollerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

//图片控件点击事件
@property (nonatomic, copy) void (^imageAction)(NSInteger index);

//图片数组
@property (nonatomic, strong) NSMutableArray *cellImages;

//使用UICollectionView实现轮播
@property (nonatomic, weak) UICollectionView *collectionView;

//分页控件
@property (nonatomic, weak) UIPageControl *pageControl;

//定时器
@property (nonatomic, strong) NSTimer *timer;

//判断手动拖拽后是否需要启动定时器
@property (nonatomic, assign) BOOL userTiming;

//监控当前页面下标
@property (nonatomic, assign) NSInteger pageIndex;

//监控偏移量
@property (nonatomic, copy) void (^offsetAction)(CGPoint offset);

//描述数组
@property (nonatomic, strong) NSMutableArray *describes;

//描述标签的frame
@property (nonatomic, assign) CGRect describeFrame;

@end

@implementation WYScrollerView

//构造方法
- (instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images Action:(void (^)(NSInteger))action {
    
    if(self == [super initWithFrame:frame]) {
        
        _imageAction = action;
        [self initViewWithImages:images];
    }
    
    return self;
}

//添加图片到数组中
- (void)initViewWithImages:(NSArray *)images {
    
    if(images.count <= 0) return;
    self.infiniteShuffling = YES;
    self.standingTime = 3;
    self.pageIndex = 1;
    if(images.count == 1) {
        
        self.cellImages = [NSMutableArray arrayWithCapacity:1];
        [_cellImages addObjectsFromArray:images];
        
    }else {
        
        self.cellImages = [NSMutableArray arrayWithCapacity:images.count+2];
        [_cellImages addObject:[images lastObject]];
        [_cellImages addObjectsFromArray:images];
        [_cellImages addObject:[images firstObject]];
    }
    
    
    [self addSubview:self.collectionView];
    
    //只有当轮播数大于1时，才显示分页控件
    if(images.count > 1) {
        
        [self addSubview:self.pageControl];
    }
}

- (void)setImages:(NSArray *)images {
    
    if(images.count <= 0) {return;};
    self.pageIndex = 1;
    if(images.count == 1) {
        
        self.cellImages = [NSMutableArray arrayWithCapacity:1];
        [_cellImages addObjectsFromArray:images];
        
    }else {
        
        self.cellImages = [NSMutableArray arrayWithCapacity:images.count+2];
        [_cellImages addObject:[images lastObject]];
        [_cellImages addObjectsFromArray:images];
        [_cellImages addObject:[images firstObject]];
    }
    
    //只有当轮播数大于1时，才显示分页控件
    if(images.count > 1) {
        
        [self addSubview:self.pageControl];
    }
    
    [_collectionView reloadData];
}

//当不需要循环滚动时移除首尾共2张添加的图片
- (void)setInfiniteShuffling:(BOOL)infiniteShuffling {
    
    _infiniteShuffling = infiniteShuffling;
    if(infiniteShuffling == NO) {
        
        [_cellImages removeObjectAtIndex:0];
        [_cellImages removeLastObject];
    }
    
    [self stopTimer];
}

//设置pageControl的原点位置后重新布局
- (void)setPageControlPoint:(CGPoint)pageControlPoint {
    
    _pageControlPoint = pageControlPoint;
    _pageControl.frame = CGRectMake(pageControlPoint.x, pageControlPoint.y, _pageControl.frame.size.width, _pageControl.frame.size.height);
}

//设置pageControl的指示器图片
- (void)updatePageControlImage:(UIImage *)image CurrentImage:(UIImage *)currentImage {
    
    if (!image || !currentImage) return;
    _pageControl.numberOfPages = _cellImages.count-2;
    [_pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [_pageControl setValue:image forKey:@"_pageImage"];
}

//设置pageControl的指示器颜色
-(void)updatePageControlColor:(UIColor *)color CurrentPageColor:(UIColor *)currentColor {
    
    _pageControl.pageIndicatorTintColor = color;
    _pageControl.currentPageIndicatorTintColor = currentColor;
}

//设置描述标签
- (void)layoutLabelWithDescribes:(NSArray *)describes Frame:(CGRect)frame {
    
    if(describes.count > 0) {
        
        if(describes.count == 1) {
            
            self.describes = [NSMutableArray arrayWithCapacity:1];
            [_describes addObjectsFromArray:describes];
            
        }else {
            
            self.describes = [NSMutableArray arrayWithCapacity:describes.count+2];
            [_describes addObject:[describes lastObject]];
            [_describes addObjectsFromArray:describes];
            [_describes addObject:[describes firstObject]];
        }
        
        self.describeFrame = (frame.size.height > 0) ? frame : CGRectMake(20, self.frame.size.height-60, self.frame.size.width-40, 60);
    }
}

//获取偏移量
- (void)getOffsetAction:(void (^)(CGPoint))action {
    
    _offsetAction = action;
}

//开启定时器
- (void)startTimer {
    
    //如果只有一张图片或设置不需要滚动，则直接返回，不开启定时器
    if ((_cellImages.count <= 1) || (_infiniteShuffling == NO)) return;
    //如果定时器已开启，先停止再重新开启
    if (_timer) [self stopTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(_standingTime < 1) ? 3 : _standingTime target:self selector:@selector(nextPage) userInfo:NULL repeats:YES];
    self.userTiming = YES;
}

//关闭定时器
- (void)stopTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

//自动翻页
- (void)nextPage {
    
    if(_cellImages.count > 1) {
        
        if(_pageIndex == (_cellImages.count)) {
            
            _pageIndex = 1;
        }
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_pageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
        _pageIndex++;
    }
}

//实现代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _cellImages.count;
}

//页面显示UI处理部分
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYScrollerViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WYScrollerViewCell" forIndexPath:indexPath];
    cell.placeholderImage = _placeholderImage;
    [cell updateCollectionViewCellImage:[_cellImages objectAtIndex:indexPath.row] describe:[_describes objectAtIndex:indexPath.row] describeFrame:_describeFrame];
    return cell;
}

//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(_imageAction) {
        
        if(_cellImages.count > 1) {
            
            _imageAction(indexPath.item-1);
            
        }else {
            
            _imageAction(indexPath.item);
        }
    }
}

//设置初始页面为第一页
- (void)layoutSubviews {
    
    [super layoutSubviews];
    if(_cellImages.count > 1) {
        
        if(_infiniteShuffling == YES) {
            
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
}

//开始拖动是停止定时器,
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopTimer];
}

//关键部分，实现无限轮播
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(_offsetAction) {
        
        //为了实现无缝监控，必须在偏移量变动后就监听
        _offsetAction(scrollView.contentOffset);
    }
    
    //设置图片无限轮播
    [self layoutCellImage];
    
    if(_pageControl) {
        
        //设置分页
        [self layoutCellPage];
    }
}

//判断是否重启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if((_userTiming == YES) && (_infiniteShuffling == YES)) {
        
        [self startTimer];
    }
}

- (void)layoutCellImage {
    
    CGFloat offSetX = _collectionView.contentOffset.x;
    
    if(_infiniteShuffling == YES) {
        
        if (offSetX <= 0) {//左滑
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_cellImages.count - 2 inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        
        if (offSetX >= _collectionView.bounds.size.width * (_cellImages.count - 1)) {//右滑
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }else {
        
        _collectionView.alwaysBounceHorizontal = NO;
    }
}

- (void)layoutCellPage {
    
    double numPage = _collectionView.contentOffset.x / _collectionView.frame.size.width;
    if(_infiniteShuffling == YES) {
        
        if (numPage == 0) {
            
            _pageControl.currentPage = _pageControl.numberOfPages - 1;
            
        }else if (numPage == _cellImages.count - 1) {
            
            _pageControl.currentPage = 0;
            
        }else{
            
            _pageControl.currentPage = numPage - 1;
        }
        
    }else {
        
        _pageControl.currentPage = numPage;
    }
    
    _pageIndex = numPage;
}

//懒加载UICollectionView
- (UICollectionView *)collectionView {
    
    if(!_collectionView) {
        
        // 流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        // 设置滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.f;
        layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        UICollectionView *collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        [collectionview registerClass:[WYScrollerViewCell class] forCellWithReuseIdentifier:@"WYScrollerViewCell"];
        collectionview.delegate = self;
        collectionview.dataSource = self;
        collectionview.showsHorizontalScrollIndicator = NO;
        collectionview.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        
        _collectionView = collectionview;
    }
    
    return _collectionView;
}


//懒加载分页指示器
- (UIPageControl *)pageControl {
    
    if(!_pageControl) {
        
        UIPageControl *page = [[UIPageControl alloc]init];
        page.userInteractionEnabled = NO;
        page.currentPage = 0;
        CGSize size = [page sizeForNumberOfPages:_cellImages.count-2];
        size.height = 8;
        page.frame = CGRectMake((self.frame.size.width-size.width)/2, self.frame.size.height-30, size.width, 8);
        page.numberOfPages = _cellImages.count-2;
        _pageControl = page;
    }
    
    return _pageControl;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
