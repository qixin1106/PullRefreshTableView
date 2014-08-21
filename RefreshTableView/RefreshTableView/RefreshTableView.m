//
//  RefreshTableView.m
//  RefreshTableView
//
//  Created by gm-iMac-iOS-03 on 14-8-18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "RefreshTableView.h"

@interface RefreshTableView ()
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
            self.pullDownView = [[PullRefreshView alloc] initWithPullType:PullType_Header];
            [self.pullDownView showInScrollView:self];
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
        self.pullDownView.delegate = (id<PullRefreshViewDelegate>)delegate;
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
        self.pullDownView.delegate = (id<PullRefreshViewDelegate>)dataSource;
    }
    if (self.isPullUpValid)
    {
        self.pullUpView.delegate = (id<PullRefreshViewDelegate>)dataSource;
    }
}


@end
