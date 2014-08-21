//
//  RefreshTableView.h
//  RefreshTableView
//
//  Created by gm-iMac-iOS-03 on 14-8-18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullRefreshView;
@interface RefreshTableView : UITableView
@property (strong, nonatomic) PullRefreshView *pullDownView;
@property (strong, nonatomic) PullRefreshView *pullUpView;

- (id)initWithFrame:(CGRect)frame
              style:(UITableViewStyle)style
    isPullDownValid:(BOOL)isPullDownValid
      isPullUpValid:(BOOL)isPullUpValid;
@end
