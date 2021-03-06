//
//  ViewController.m
//  RefreshTableView
//
//  Created by gm-iMac-iOS-03 on 14-8-18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "ViewController.h"
#import "RefreshTableView.h"
#import "PullRefreshView.h"



static int row = 0;
@interface ViewController ()
<UITableViewDataSource,
UITableViewDelegate,
PullRefreshViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) RefreshTableView *tableView;
@end

@implementation ViewController

#pragma mark - 模拟加载数据
- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool
        {
            sleep(2.0f);
            row = 0;
            [self.dataArray removeAllObjects];
            for (int i = 0; i < 20; i++)
            {
                row++;
                [self.dataArray addObject:[NSString stringWithFormat:@"标题%d %f",row,CFAbsoluteTimeGetCurrent()]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView pullDownFinish];
            });
        }
    });

}

#pragma mark - 模拟加载数据
- (void)addData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool
        {
            sleep(1.0f);
            for (int i = 0; i < 20; i++)
            {
                row++;
                [self.dataArray addObject:[NSString stringWithFormat:@"标题%d %f",row,CFAbsoluteTimeGetCurrent()]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView pullUpFinish];
            });
        }
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    self.dataArray = [NSMutableArray array];
    [self loadData];

    float screenHeight= [[UIScreen mainScreen] bounds].size.height;
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    nav.backgroundColor = [UIColor colorWithRed:151/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self.view addSubview:nav];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Home Page";
    [nav addSubview:titleLabel];

    //初始化TableView
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 64, 320, screenHeight-64)
                                                       style:UITableViewStylePlain
                                             isPullDownValid:YES
                                               isPullUpValid:YES];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}


#pragma mark - PullRefreshViewDelegate
- (void)didBeginLoadData:(PullRefreshView*)pullRefreshView
{
    if (pullRefreshView.pullType==PullType_Header)
    {
        [self loadData];
    }
    if (pullRefreshView.pullType==PullType_Footer)
    {
        [self addData];
    }
}





#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"WTF";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}

@end
