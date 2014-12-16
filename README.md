PullRefreshTableView
===================


### 初始化
    
    //下拉刷新
    self.pullDonwView = [[PullRefreshView alloc] initWithPullType:PullType_Header];
    self.pullDonwView.delegate = self;
    [self.pullDonwView showInScrollView:self.tableView];
 
    //上拉加载更多
    self.pullUpView = [[PullRefreshView alloc] initWithPullType:PullType_Footer];
    self.pullUpView.delegate = self;
    [self.pullUpView showInScrollView:self.tableView];
 
### delegate
 
    #pragma mark - PullRefreshViewDelegate
    - (void)didBeginLoadData:(PullRefreshView*)pullRefreshView
    {
        if (pullRefreshView.pullType==PullType_Header)
        {
            //TODO: request data...
        }
        if (pullRefreshView.pullType==PullType_Footer)
        {
            //TODO: request data...
        }
    }

### 请求完成

     //didLoadFinish 内部实现回调到主线程,因此,不需要实现切入主线程操作
    [self.pullDownView didLoadFinish];
    [self.pullUpView didLoadFinish];

