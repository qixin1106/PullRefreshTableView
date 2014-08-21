//
//  RefreshTableView.h
//  RefreshTableView
//
//  Created by gm-iMac-iOS-03 on 14-8-18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

/*
 使用方式

 self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 64, 320, screenHeight-64)
                                                    style:UITableViewStylePlain
                                          isPullDownValid:YES
                                            isPullUpValid:YES];
 self.tableView.delegate = self;
 self.tableView.dataSource = self;
 [self.view addSubview:self.tableView];

 */

#import <UIKit/UIKit.h>
#import "PullRefreshView.h"

@interface RefreshTableView : UITableView
@property (strong, nonatomic) PullRefreshView *pullDownView;
@property (strong, nonatomic) PullRefreshView *pullUpView;

- (id)initWithFrame:(CGRect)frame
              style:(UITableViewStyle)style
    isPullDownValid:(BOOL)isPullDownValid
      isPullUpValid:(BOOL)isPullUpValid;
@end
