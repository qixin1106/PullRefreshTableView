//
//  PullDownRefreshView.m
//  RefreshTableView
//
//  Created by gm-iMac-iOS-03 on 14-8-18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//  GM

#import "PullRefreshView.h"
#import <QuartzCore/QuartzCore.h>

#define OFFSETHEIGHT 65
#define FLIP_ANIMATION_DURATION 0.25

#define PULLDOWN @"下拉马上刷新"
#define DOWNRELEASE @"释放立马刷新"
#define DOWNLOADING @"正在刷新..."

#define PULLUP @"上拉马上加载"
#define UPRELEASE @"释放立马加载"
#define UPLOADING @"正在加载..."

#define LAST_REFRESH_DATE @"kPullRefreshLastHeaderDateTime"


typedef enum {
    State_Normal=0,
    State_PreRefesh=1,
    State_Shake=2
}State;

@interface PullRefreshView ()
//base
@property (weak, nonatomic) UIScrollView *scrollView;
//UI,可自定义
@property (strong, nonatomic) UIView *layoutView;//放布局的
@property (strong, nonatomic) UILabel *titleLabel;//标题
@property (strong, nonatomic) UILabel *refreshLabel;//刷新时间
@property (strong, nonatomic) UIActivityIndicatorView *aiView;//菊花
@property (strong, nonatomic) UIImageView *horse;//小马
@property (assign, nonatomic) State state;
@end

@implementation PullRefreshView


#pragma mark - 初始化
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
        self.layoutView = [[UIView alloc] init];
        self.layoutView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.layoutView];


        if (self.pullType==PullType_Header)
        {
            [self headerLayout];
        }
        if (self.pullType==PullType_Footer)
        {
            [self footerLayout];
        }

    }
    return self;
}


#pragma mark - 加载方法
- (void)showInScrollView:(UIScrollView*)scrollView
{
    NSAssert([scrollView isKindOfClass:[UIScrollView class]], @"必须是UIScrollView或其子类");
    self.scrollView = scrollView;
    [self.scrollView addSubview:self];

    [self.scrollView addObserver:self
                     forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                        context:NULL];
    [self.scrollView addObserver:self
                     forKeyPath:@"contentSize"
                        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                        context:NULL];

}

#pragma mark - 刷新Frame时,子控件改变布局
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.pullType == PullType_Header)
    {
        self.layoutView.frame = CGRectMake(0, frame.size.height-OFFSETHEIGHT, frame.size.width, OFFSETHEIGHT);
    }
    else
    {
        self.layoutView.frame = CGRectMake(0, 0, frame.size.width, OFFSETHEIGHT);
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
                    self.titleLabel.text = DOWNLOADING;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didBeginLoadData:)])
                    {
                        //???: 只有下拉刷新才有时间
                        [self changeLastRefreshDateTime];
                        [self.delegate didBeginLoadData:self];
                    }
                    
                    [UIView animateWithDuration:0.15f animations:^{
                        if (self.pullType==PullType_Header)
                        {
                            self.scrollView.contentInset = UIEdgeInsetsMake(OFFSETHEIGHT,
                                                                            self.scrollView.contentInset.left,
                                                                            self.scrollView.contentInset.bottom,
                                                                            self.scrollView.contentInset.right);
                        }
                    }];
                    //TODO: 小马动画晃动
                    self.state = State_Shake;
                }
                //在可请求得距离,未松手
                else
                {
                    self.titleLabel.text = DOWNRELEASE;
                    //TODO: 小马动画准备
                    self.state = State_PreRefesh;
                }
            }
            //距离完全不够
            else
            {
                self.titleLabel.text = PULLDOWN;
                //TODO: 小马动画复位
                self.state = State_Normal;
            }
        }
        else
        {
            self.titleLabel.text = DOWNLOADING;
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
                self.titleLabel.text = UPLOADING;
                if (self.delegate && [self.delegate respondsToSelector:@selector(didBeginLoadData:)])
                {
                    [self.delegate didBeginLoadData:self];
                }
                [UIView animateWithDuration:0.15f animations:^{
                    if (self.pullType==PullType_Footer)
                    {
                        self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                                       self.scrollView.contentInset.left,
                                                                       OFFSETHEIGHT,
                                                                       self.scrollView.contentInset.right);
                    }
                }];
            }
            //在可请求得距离,未松手
            else if (oldPoint.y+self.scrollView.bounds.size.height>self.scrollView.contentSize.height+OFFSETHEIGHT &&
                     self.scrollView.tracking)
            {
                self.titleLabel.text = UPRELEASE;
            }
            //距离完全不够
            else
            {
                self.titleLabel.text = PULLUP;
            }
        }
        else
        {
            self.titleLabel.text = UPLOADING;
        }
    }
}


#pragma mark - 完成加载
- (void)didLoadFinish
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //TODO: 小马动画复位
        self.state = State_Normal;

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






#pragma mark - 获得时间
- (void)changeLastRefreshDateTime
{
    NSDate *creationDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *currentDateStr = [NSString stringWithFormat:@"上次刷新:%@",[dateFormatter stringFromDate:creationDate]];
    [[NSUserDefaults standardUserDefaults] setObject:currentDateStr forKey:LAST_REFRESH_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.refreshLabel.text = currentDateStr;
}




#pragma mark - 自定义UI及动画
- (void)setState:(State)state
{
    if (_state!=state)
    {
        _state=state;
        switch (_state)
        {
            case State_Normal:
            {
                [self.horse.layer removeAllAnimations];
                [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
                    self.horse.transform = CGAffineTransformMakeRotation(0);
                }];
                break;
            }
            case State_PreRefesh:
            {
                [self.horse.layer removeAllAnimations];
                [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
                    self.horse.transform = CGAffineTransformMakeRotation((M_PI / 180.0) * 30.0f);
                }];
                break;
            }
            case State_Shake:
            {
                [self.horse.layer removeAllAnimations];
                self.horse.layer.transform = CATransform3DIdentity;

                CABasicAnimation*animation=[CABasicAnimation animationWithKeyPath:@"transform"];
                animation.duration = 0.5f;
                animation.repeatCount = MAXFLOAT;
                animation.autoreverses = YES;
                animation.removedOnCompletion = YES;
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.horse.layer.transform, (M_PI / 180.0) * 30.0f, 0.0, 0.0, 1)];
                animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.horse.layer.transform, (M_PI / 180.0) * -30.0f, 0.0, 0.0, 1)];
                [self.horse.layer addAnimation:animation forKey:@"wiggle"];
                break;
            }
            default:
                break;
        }
    }
}


- (void)headerLayout
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(130, 15, 100, 20);
    self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.opaque = YES;
    [self.layoutView addSubview:self.titleLabel];


    self.refreshLabel = [[UILabel alloc] init];
    self.refreshLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_REFRESH_DATE];
    self.refreshLabel.frame = CGRectMake(130, 35, 100, 20);
    self.refreshLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.refreshLabel.font = [UIFont systemFontOfSize:12.0f];
    self.refreshLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    self.refreshLabel.backgroundColor = [UIColor clearColor];
    [self.layoutView addSubview:self.refreshLabel];


    self.horse = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_xiaoma.png"]];
    self.horse.layer.anchorPoint = CGPointMake(0.5, 0.9);
    self.horse.frame = CGRectMake(80, 22, 36, 27);
    [self.layoutView addSubview:self.horse];
}

- (void)footerLayout
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(130, 15, 100, 20);
    self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.opaque = YES;
    [self.layoutView addSubview:self.titleLabel];

    self.aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.aiView.frame = CGRectMake(110, 25, 0, 0);
    self.aiView.hidesWhenStopped = YES;
    [self.layoutView addSubview:self.aiView];
}




@end
