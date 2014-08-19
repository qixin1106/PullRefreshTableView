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
- (id)initWithFrame:(CGRect)frame
              style:(UITableViewStyle)style
    isPullDownValid:(BOOL)isPullDownValid
      isPullUpValid:(BOOL)isPullUpValid;
- (void)pullDownFinish;//下拉加载完成
- (void)pullUpFinish;//上拉加载完成
@end
