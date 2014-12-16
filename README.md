PullRefreshTableView
===================


演示效果:

### 下拉刷新
![image](https://raw.githubusercontent.com/qixin1106/PullRefreshTableView/master/up.gif)

### 上拉加载更多
![image](https://raw.githubusercontent.com/qixin1106/PullRefreshTableView/master/down.gif)


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



### 新增加方法

    //如果是最后一页数据,则调此方法,可现实"全部加载完成"并,关闭KVO监听方法.
    - (void)finishDataHandle;
    //打开KVO监听方法,每次移动会自己替换文字
    - (void)startDataHandle;
