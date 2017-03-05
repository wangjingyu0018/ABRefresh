//
//  ABSideLoadMore.m
//  侧滑刷新
//
//  Created by wjy0916 on 17/3/5.
//  Copyright © 2017年 AB.ios. All rights reserved.
//

#import "ABSideLoadMore.h"


#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width
static const CGFloat ABRefreshControlW = 45;

@interface ABSideLoadMore ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;           //帧动画图片
@property (nonatomic, strong) UILabel *message;                 //显示的文字（和帧动画二选一）
@property (nonatomic, assign) ABLoadMoreStatus status;
@property (nonatomic, assign) ABLoadMoreStatus oldStatus;
@property (nonatomic, copy) loadMore loadMoreBlock;

@end

@implementation ABSideLoadMore


+(ABSideLoadMore *)loadMoreWihtBlock:(loadMore)loadMoreBlock{
    ABSideLoadMore *loadMore = [[ABSideLoadMore alloc] init];
    loadMore.loadMoreBlock = loadMoreBlock;
    [loadMore addTarget:loadMore action:@selector(loading) forControlEvents:UIControlEventValueChanged];
    return loadMore;
}
//执行加载动画
-(void)loading{
    if (self.loadMoreBlock) {
        self.loadMoreBlock();
    }
}
//设置帧动画图片
-(void)setImages:(NSArray *)images{
    self.imageView.animationImages = images;
    self.imageView.animationDuration = 0.5;
    self.imageView.animationRepeatCount = NSIntegerMax;
    self.imageView.image = images.firstObject;
}
//结束加载
-(void)endLoadMore{
    self.status = ABLoadMoreStatusNormal;
}
//开始加载
-(void)beginLoadMore{
    self.status = ABLoadMoreStatusLoading;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.frame = CGRectMake(_scrollView.contentSize.width, self.frame.origin.y, ABRefreshControlW, SCREENH);
        // 添加子控件（根据实际情况修改，位置自己调）
        [self addSubview:self.imageView];
        self.imageView.frame = CGRectMake(0, 0, 30, 30);
        self.imageView.center = CGPointMake(self.center.x, self.center.y);
        
        //文字和图片只能显示一种，如果有帧动画，隐藏文字（不添加也可以......）
        [self addSubview:self.message];
        self.message.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.message.hidden = YES;
        
        //因为这个时候无法确认加载视图的位置，所以先隐藏，在下边即将出来时再设置位置和显示
        self.hidden = YES;
    }
    return self;
}

-(void)setStatus:(ABLoadMoreStatus)status{
    self.oldStatus = _status;
    _status = status;
    // 通过更改的状态,去设置当前刷新控件的界面
    switch (_status) {
        case ABLoadMoreStatusPulling:
            self.message.text = @"放开起飞";
            NSLog(@"松开就刷新的状态");
            break;
        case ABLoadMoreStatusNormal:
            NSLog(@"默认状态");
            // 要去判断之前的状态是否是刷新??如果是刷新才去减 left
            if (self.oldStatus == ABLoadMoreStatusLoading) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.25 animations:^{
                        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - SCREENW, 0) animated:YES];
                    } completion:^(BOOL finished) {
                        self.message.text = @"下拉加载";
                        [self.imageView stopAnimating];
                    }];
                });
            }
            break;
        case ABLoadMoreStatusLoading:
            NSLog(@"刷新状态");
            self.message.text = @"正在起飞";
            [UIView animateWithDuration:0.25 animations:^{
                CGPoint offect = CGPointMake(self.scrollView.contentSize.width - SCREENW + ABRefreshControlW, 0);
                [self.scrollView setContentOffset:offect animated:YES];
                
            }];
            [self.imageView startAnimating];
            // 系统会去找 ValueChanged 对应的 target 与 action 并且去调用
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
        // 添加 scrollView　的滚动监听 contentOffset
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    // 当前 scrollView 的滚动的 x 方向的偏移量
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    // 左边内边距
    CGFloat contentSizeW = self.scrollView.contentSize.width - SCREENW;
    // 根据滚动位置,判断当前控件是否真的完全显示出来了
    // 分析出来,只要 contentOffsetX < scrollView.contentSize + ABRefreshControlW代表没有完全显示出来
    // 否则,就完全显示出来了
    CGFloat conditionValue = contentOffsetX - contentSizeW;
    if (conditionValue < 0) {
        return;
    }
    if (self.hidden) {
        self.frame = CGRectMake(_scrollView.contentSize.width, self.frame.origin.y, ABRefreshControlW, SCREENH);
        self.hidden = NO;
    }
    if (self.scrollView.dragging) {
        if (conditionValue < ABRefreshControlW) {
            if (self.status == ABLoadMoreStatusPulling) {
                self.status = ABLoadMoreStatusNormal;
            }
        }else{
            if (self.status == ABLoadMoreStatusNormal) {
                self.status = ABLoadMoreStatusPulling;
            }
        }
    }else{
        // 手松开
        // 判断当前控件是否完全显示出来(当前状态是否是`松手就可以刷新的状态`)
        if (self.status == ABLoadMoreStatusPulling) {
            self.status = ABLoadMoreStatusLoading;
        }
    }
}

#pragma mark - 懒加载
-(UILabel *)message{
    if (!_message) {
        _message = [[UILabel alloc] init];
        _message.numberOfLines = 0;
        _message.text = @"下拉加载";
        _message.textColor = [UIColor redColor];
        _message.textAlignment = NSTextAlignmentCenter;
    }
    return _message;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

-(void)dealloc{
    NSLog(@"LoadMore Dealloc");
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
