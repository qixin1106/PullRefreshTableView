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

- (void)loadData
{
    row = 0;
    [self.dataArray removeAllObjects];
    for (int i = 0; i < 20; i++)
    {
        row++;
        [self.dataArray addObject:[NSString stringWithFormat:@"标题%d %f",row,CFAbsoluteTimeGetCurrent()]];
    }
}

- (void)addData
{
    for (int i = 0; i < 20; i++)
    {
        row++;
        [self.dataArray addObject:[NSString stringWithFormat:@"标题%d %f",row,CFAbsoluteTimeGetCurrent()]];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self loadData];
    
    self.tableView = [[RefreshTableView alloc] initWithFrame:self.view.bounds
                                                       style:UITableViewStylePlain
                                             isPullDownValid:YES
                                               isPullUpValid:YES];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}


#pragma mark - 开始加载
- (void)didBeginLoadData:(PullRefreshView*)pullRefreshView
{
    //模拟刷新数据
    if (pullRefreshView.pullType==PullType_Header)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @autoreleasepool
            {
                sleep(2.0f);
                [self loadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView pullDownFinish];
                });
            }
        });
    }
    //模拟刷新数据
    if (pullRefreshView.pullType==PullType_Footer)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @autoreleasepool
            {
                sleep(2.0f);
                [self addData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView pullUpFinish];
                });
            }
        });
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
    return cell;
}

@end
