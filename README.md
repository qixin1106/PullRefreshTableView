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

