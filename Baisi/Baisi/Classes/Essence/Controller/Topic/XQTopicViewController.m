//
//  XQTopicViewController.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/24.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQTopicViewController.h"
#import <MJRefresh.h>
#import "XQMyFooter.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XQTopicCell.h"
#import "XQCommentViewController.h"

@interface XQTopicViewController ()
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;

@end

@implementation XQTopicViewController

static NSString * const XQTopicCellId = @"topic";

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTable];
    
    // 设置上下拉刷新
    [self setupRefresh];
    
    // 接收通知
    [self setupNote];
}

- (void)setupTable{
    self.tableView.contentInset = UIEdgeInsetsMake(XQNavBarMaxY + XQTitlesViewH, 0, XQTabBarH, 0);
    // self.tableView.y = 0;
    // 将滚动条的范围限制在contentInset中
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XQColor(215, 215, 215);
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XQTopicCell class]) bundle:nil] forCellReuseIdentifier:XQTopicCellId];
}

// 下拉刷新
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 进入自动刷新
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [XQMyFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (void)loadNewTopics
{
    // 取消其他请求，比如上拉。让所有task执行同一方法
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    
    XQWeakSelf
    
    // 发送请求
    [self.manager GET:XQRequestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakSelf.topics = [XQTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        XQLog(@"%@", responseObject);
        
        // 存储maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTopics
{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"maxtime"] = self.maxtime;
    
    XQWeakSelf
    
    // 发送请求
    [self.manager GET:XQRequestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *moreTopics = [XQTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [weakSelf.topics addObjectsFromArray:moreTopics];
        // 存储maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 接收通知和监听
- (void)setupNote
{
    // 接收tabBar按钮发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:XQTabBarButtonDidRepeatClickNotification object:nil];
    // 接收titleButton发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:XQTitleButtonDidRepeatClickNotification object:nil];
}

- (void)tabBarButtonDidRepeatClick
{
    // 过滤掉非精华和新帖tabBarButton发出的通知和不在主window的通知
    if (self.view.window == nil) return;
    
    if (![self.view xq_isIntersectsRect:self.view.window]) return;
    
    // 开始刷新
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)titleButtonDidRepeatClick
{
    [self tabBarButtonDidRepeatClick];
}

// 移除监听
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    XQLog(@"%zd", self.topics.count);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XQTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:XQTopicCellId forIndexPath:indexPath];
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 在这个方法中，已经将cell的高度 和 中间内容的frame 计算完毕
//    XMGTopic *topic = self.topics[indexPath.row];
    XQTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XQCommentViewController *commentVC = [[XQCommentViewController alloc] init];
    commentVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 仅仅是为了消除未实现方法的警告
- (XQTopicType)type
{
    return 0;
}


@end
