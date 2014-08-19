//
//  RefreshTableView.m
//  RefreshTableView
//
//  Created by gm-iMac-iOS-03 on 14-8-18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "RefreshTableView.h"
#import "PullRefreshView.h"

@interface RefreshTableView ()
@property (strong, nonatomic) PullRefreshView *pullDonwView;
@property (strong, nonatomic) PullRefreshView *pullUpView;
@property (assign, nonatomic) BOOL isPullDownValid;
@property (assign, nonatomic) BOOL isPullUpValid;
@end


@implementation RefreshTableView

- (id)initWithFrame:(CGRect)frame
              style:(UITableViewStyle)style
    isPullDownValid:(BOOL)isPullDownValid
      isPullUpValid:(BOOL)isPullUpValid
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.isPullDownValid = isPullDownValid;
        self.isPullUpValid = isPullUpValid;
        //下拉
        if (self.isPullDownValid)
        {
            self.pullDonwView = [[PullRefreshView alloc] initWithPullType:PullType_Header];
            [self.pullDonwView showInScrollView:self];
        }

        //上拉
        if (self.isPullUpValid)
        {
            self.pullUpView = [[PullRefreshView alloc] initWithPullType:PullType_Footer];
            [self.pullUpView showInScrollView:self];
        }
    }
    return self;
}


#pragma mark - 给控件delegate赋值
- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    [super setDelegate:delegate];
    if (self.isPullDownValid)
    {
        self.pullDonwView.delegate = (id<PullRefreshViewDelegate>)delegate;
    }
    if (self.isPullUpValid)
    {
        self.pullUpView.delegate = (id<PullRefreshViewDelegate>)delegate;
    }
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    [super setDataSource:dataSource];
    if (self.isPullDownValid)
    {
        self.pullDonwView.delegate = (id<PullRefreshViewDelegate>)dataSource;
    }
    if (self.isPullUpValid)
    {
        self.pullUpView.delegate = (id<PullRefreshViewDelegate>)dataSource;
    }
}

- (void)pullDownFinish
{
    [self.pullDonwView didLoadFinish];
}
- (void)pullUpFinish
{
    [self.pullUpView didLoadFinish];
}

@end
