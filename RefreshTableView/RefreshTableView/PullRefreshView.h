//
//  PullDownRefreshView.h
//  RefreshTableView
//
//  Created by Qixin on 14-8-18.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//


#pragma mark - 使用示例
/*************1.初始化*******************************************
 //必须使用 showInScrollView 方法来addSubViews,不需要再次addSubViews
 
 //下拉刷新
 self.pullDonwView = [[PullRefreshView alloc] initWithPullType:PullType_Header];
 self.pullDonwView.delegate = self;
 [self.pullDonwView showInScrollView:self.tableView];
 
 //上拉加载更多
 self.pullUpView = [[PullRefreshView alloc] initWithPullType:PullType_Footer];
 self.pullUpView.delegate = self;
 [self.pullUpView showInScrollView:self.tableView];
 *****************************************************/




/*************2.delegate*******************************************
 //当开始请求状态回调
 - (void)didBeginLoadData:(PullRefreshView*)pullRefreshView
 {
 if (pullRefreshView.pullType==PullType_Header)
 {
 //请求数据...
 }
 if (pullRefreshView.pullType==PullType_Footer)
 {
 //请求数据...
 }
 }
 *****************************************************/



/*************3.请求完成*******************************************
 //请求完成时候,通知控件收回.按需使用
 //didLoadFinish 内部实现回调到主线程,因此,不需要实现切入主线程操作
 [self.pullDownView didLoadFinish];
 [self.pullUpView didLoadFinish];
 *****************************************************/



#pragma mark - 代码
#import <UIKit/UIKit.h>

typedef enum
{
    PullType_Header=0,
    PullType_Footer=1
}PullType;


@protocol PullRefreshViewDelegate;
@interface PullRefreshView : UIView
@property (weak, nonatomic) id<PullRefreshViewDelegate>delegate;
@property (assign, nonatomic) PullType pullType;//PullType_Header下拉, PullType_Footer上拉
@property (assign, nonatomic) BOOL isLoading;//只能防止上拉或下拉某一个控件重复请求,如需做总控制,请自行实现

@property (copy, nonatomic) NSString *normalTitle;//正常状态
@property (copy, nonatomic) NSString *willLoadTitle;//临界状态
@property (copy, nonatomic) NSString *loadingTitle;//加载状态

//设置3个状态的文字,可以随时改
- (void)normalTitle:(NSString*)normalTitle
      willLoadTitle:(NSString*)willLoadTitle
       loadingTitle:(NSString*)loadingTitle;


//初始化
- (id)initWithPullType:(PullType)pullType;


//加载到视图(务必用该方法加载)
- (void)showInScrollView:(UIScrollView*)scrollView;


//通知控件加载完成(网络请求结束)执行收起动画
- (void)didLoadFinish;


//如果是最后一页数据,则调此方法,可现实"全部加载完成"并,关闭KVO监听方法.
- (void)finishDataHandle;


//打开KVO监听方法,每次移动会自己替换文字
- (void)startDataHandle;

@end





@protocol PullRefreshViewDelegate <NSObject>
//可以加载数据通知->动画已经进入加载状态(你可以在次回调中起线程请求数据,当数据请求完成调用didLoadFinish,通知收起动画)
- (void)didBeginLoadData:(PullRefreshView*)pullRefreshView;
@end