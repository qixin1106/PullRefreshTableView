//
//  PullDownRefreshView.m
//  RefreshTableView
//
//  Created by Qixin on 14-8-18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "PullRefreshView.h"

#define OFFSETHEIGHT 80
#define LOADINGHEIGHT 49

#define PULLDOWN @"下拉刷新?"
#define RELEASE @"释放加载!"
#define LOADING @"加载中..."
#define PULLUP @"上拉加载?"


@interface PullRefreshView ()
//base
@property (weak, nonatomic) UIScrollView *scrollView;
//UI,可自定义
@property (strong, nonatomic) UILabel *titleLabel;//标题
@property (strong, nonatomic) UIActivityIndicatorView *aiView;//菊花
@end

@implementation PullRefreshView

- (void)normalTitle:(NSString*)normalTitle
      willLoadTitle:(NSString*)willLoadTitle
       loadingTitle:(NSString*)loadingTitle
{
    self.normalTitle = normalTitle;
    self.willLoadTitle = willLoadTitle;
    self.loadingTitle = loadingTitle;
}

- (void)finishDataHandle
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.aiView stopAnimating];
    self.hidden = YES;
}

- (void)startDataHandle
{
    self.hidden = NO;
    [self.scrollView addObserver:self
                      forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                         context:NULL];
    [self.scrollView addObserver:self
                      forKeyPath:@"contentSize"
                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                         context:NULL];
}


- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (id)initWithPullType:(PullType)pullType
{
    self = [super init];
    if (self)
    {
        self.clipsToBounds = YES;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.pullType = pullType;
        self.isLoading = NO;
        
        //TODO: 自定义UI布局
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.opaque = YES;
        [self addSubview:self.titleLabel];
        
        self.aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.aiView.hidesWhenStopped = YES;
        [self addSubview:self.aiView];
    }
    return self;
}


#pragma mark - 加载方法
- (void)showInScrollView:(UIScrollView*)scrollView
{
    NSAssert([scrollView isKindOfClass:[UIScrollView class]], @"必须是UIScrollView或其子类");
    self.scrollView = scrollView;
    [self.scrollView addSubview:self];
    //开始监听移动
    [self startDataHandle];
}



#pragma mark - 刷新Frame时,子控件改变布局
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.pullType == PullType_Header)
    {
        self.titleLabel.frame = CGRectMake(self.scrollView.frame.size.width*0.5-100*0.5, frame.size.height-25, 100, 20);
        self.aiView.frame = CGRectMake(self.scrollView.frame.size.width*0.5-100*0.5-50, frame.size.height-15, 0, 0);
    }
    else
    {
        self.titleLabel.frame = CGRectMake(self.scrollView.frame.size.width*0.5-100*0.5, 10, 100, 20);
        self.aiView.frame = CGRectMake(self.scrollView.frame.size.width*0.5-100*0.5-50, 20, 0, 0);
    }
}

#pragma mark - Change Offset
- (void)changeOffset:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint
{
    //TODO: 下拉刷新
    if (self.pullType==PullType_Header)
    {
        if (oldPoint.y<0)
        {
            self.frame = CGRectMake(0, oldPoint.y, self.scrollView.bounds.size.width, -oldPoint.y);
        }
        if (!self.isLoading)
        {
            if (oldPoint.y<-OFFSETHEIGHT)
            {
                //在可请求得距离松手
                if (!self.scrollView.tracking)
                {
                    [self.aiView startAnimating];
                    self.isLoading = YES;
                    self.titleLabel.text = (self.loadingTitle.length)?self.loadingTitle:LOADING;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didBeginLoadData:)])
                    {
                        [self.delegate didBeginLoadData:self];
                    }
                    [UIView animateWithDuration:0.25f animations:^{
                        if (self.pullType==PullType_Header)
                        {
                            self.scrollView.contentInset = UIEdgeInsetsMake(LOADINGHEIGHT,
                                                                            self.scrollView.contentInset.left,
                                                                            self.scrollView.contentInset.bottom,
                                                                            self.scrollView.contentInset.right);
                        }
                    }];
                }
                //在可请求得距离,未松手
                else
                {
                    self.titleLabel.text = (self.willLoadTitle.length)?self.willLoadTitle:RELEASE;
                }
            }
            //距离完全不够
            else
            {
                self.titleLabel.text = (self.normalTitle.length)?self.normalTitle:PULLDOWN;
            }
        }
        else
        {
            self.titleLabel.text = (self.loadingTitle.length)?self.loadingTitle:LOADING;
        }
    }
    
    //TODO: 上拉加载
    if (self.pullType==PullType_Footer)
    {
        if (oldPoint.y>self.scrollView.contentSize.height-self.scrollView.bounds.size.height)
        {
            self.frame = CGRectMake(0,
                                    self.scrollView.contentSize.height,
                                    self.scrollView.bounds.size.width,
                                    oldPoint.y+self.scrollView.bounds.size.height-self.scrollView.contentSize.height);
        }
        if (!self.isLoading)
        {
            //在可请求得距离松手
            if (oldPoint.y+self.scrollView.bounds.size.height>self.scrollView.contentSize.height+OFFSETHEIGHT &&
                !self.scrollView.tracking)
            {
                [self.aiView startAnimating];
                self.isLoading = YES;
                self.titleLabel.text = (self.loadingTitle.length)?self.loadingTitle:LOADING;
                if (self.delegate && [self.delegate respondsToSelector:@selector(didBeginLoadData:)])
                {
                    [self.delegate didBeginLoadData:self];
                }
                [UIView animateWithDuration:0.25f animations:^{
                    if (self.pullType==PullType_Footer)
                    {
                        self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                                        self.scrollView.contentInset.left,
                                                                        LOADINGHEIGHT,
                                                                        self.scrollView.contentInset.right);
                    }
                }];
            }
            //在可请求得距离,未松手
            else if (oldPoint.y+self.scrollView.bounds.size.height>self.scrollView.contentSize.height+OFFSETHEIGHT &&
                     self.scrollView.tracking)
            {
                self.titleLabel.text = (self.willLoadTitle.length)?self.willLoadTitle:RELEASE;
            }
            //距离完全不够
            else
            {
                self.titleLabel.text = (self.normalTitle.length)?self.normalTitle:PULLUP;
            }
        }
        else
        {
            self.titleLabel.text = (self.loadingTitle.length)?self.loadingTitle:LOADING;
        }
    }
}


#pragma mark - 完成加载
- (void)didLoadFinish
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.aiView stopAnimating];
        self.isLoading = NO;
        [UIView animateWithDuration:0.25f animations:^{
            if (self.pullType==PullType_Header)
            {
                self.scrollView.contentInset = UIEdgeInsetsMake(0,
                                                                self.scrollView.contentInset.left,
                                                                self.scrollView.contentInset.bottom,
                                                                self.scrollView.contentInset.right);
            }
            if (self.pullType==PullType_Footer)
            {
                self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                                self.scrollView.contentInset.left,
                                                                0,
                                                                self.scrollView.contentInset.right);
            }
        }];
    });
}



#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        [self changeOffset:[[change objectForKey:@"new"] CGPointValue]
                  oldPoint:[[change objectForKey:@"old"] CGPointValue]];
    }
    else if ([keyPath isEqualToString:@"contentSize"])
    {
        if (self.pullType==PullType_Footer)
        {
            self.frame = CGRectMake(0,
                                    self.scrollView.contentSize.height,
                                    self.scrollView.bounds.size.width,
                                    self.frame.size.height);
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}



@end
