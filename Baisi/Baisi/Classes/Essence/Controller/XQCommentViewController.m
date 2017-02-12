//
//  XQCommentViewController.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/12.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQCommentViewController.h"
#import "XQCommentCell.h"
#import "XQCommentHeaderView.h"
#import "XQComment.h"
#import "XQTopic.h"
#import "XQTopicCell.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XQUser.h"

@interface XQCommentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论（所有的评论数据） */
@property (nonatomic, strong) NSMutableArray *latestComments;
// 缓存comment
@property (nonatomic, strong) XQComment *topComment;

/** 写方法声明的目的是为了使用点语法提示(下面有个selectedComment方法相当于get) */
- (XQComment *)selectedComment;

@end

@implementation XQCommentViewController


#pragma mark - 初始化
static NSString * const XQCommentCellId = @"comment";
static NSString * const XQHeaderId = @"header";

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setupTable];
    
    [self setupRefresh];
}

- (void)setupTable
{
    self.tableView.backgroundColor = XQColor(215, 215, 215);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XQCommentCell class]) bundle:nil] forCellReuseIdentifier:XQCommentCellId];
    [self.tableView registerClass:[XQCommentHeaderView class] forHeaderFooterViewReuseIdentifier:XQHeaderId];
    
    // 设置预估行高
    self.tableView.estimatedRowHeight = 100;
    // 设置具体动态计算行高
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 处理模型数据，将topComment缓存
    if (self.topic.topComment) {
        self.topComment = self.topic.topComment;
        self.topic.topComment = nil;
        self.topic.cellHeight = 0;
    }
    
    // celll
    XQTopicCell *cell = [XQTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, XQScreenW, self.topic.cellHeight);
    
    // 设置header
    UIView *header = [[UIView alloc] init];
    header.height = cell.height + 2 * XQCommonMargin;
    [header addSubview:cell];
    
    self.tableView.tableHeaderView = header;
}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}

#pragma mark - MJRefresh方法
- (void)loadNewComments{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @1;
    
    // 发送请求
    XQWeakSelf;
    
    [self.manager GET:XQRequestURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 意味着没有评论数据
            
            // 结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            
            // 返回
            return;
        }
        
        // 最热评论
        weakSelf.hotComments = [XQComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        weakSelf.latestComments = [XQComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
            // 已经完全加载完毕
            //            [weakSelf.tableView.footer noticeNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreComments{
    // 取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"lastcid"] = [self.latestComments.lastObject ID];
    
    // 发送请求
    XQWeakSelf;
    [self.manager GET:XQRequestURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 意味着没有评论数据
            
            // 结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            
            // 返回
            return;
        }
        // 最新评论
        NSArray *newComments = [XQComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 判断评论数据是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
            // 已经完全加载完毕
            //            [weakSelf.tableView.footer noticeNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;
        } else { // 应该还会有下一页数据
            // 结束刷新(恢复到普通状态，仍旧可以继续刷新)
            [weakSelf.tableView.mj_footer endRefreshing];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 监听
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 工具条平移的距离 == 屏幕高度 - 键盘最终的Y值
    self.bottomSpace.constant = XQScreenH - [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.hotComments.count) return 2;
    if (self.latestComments.count) return 1;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && self.hotComments.count) {
        return self.hotComments.count;
    }
    
    return self.latestComments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:XQCommentCellId];
    
    // 获得对应的评论数据
    NSArray *comments = self.latestComments;
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    }
    
    // 传递模型给cell
    cell.comment = comments[indexPath.row];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XQCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:XQHeaderId
                                    ];
    // 覆盖文字
    if (section == 0 && self.hotComments.count) {
        header.text = @"最热评论";
    } else {
        header.text = @"最新评论";
    }
    
    return header;
}
// 不设置高度，上面的方法viewForHeaderInSection不执行。。
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    // 设置菜单内容
    menu.menuItems = @[
                       [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)],
                       [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)],
                       [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)]
                       ];
    
    // 显示位置
    CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, 1);
    [menu setTargetRect:rect inView:cell];
    
    // 显示出来
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - 获得当前选中的评论
- (XQComment *)selectedComment
{
    // 获得被选中的cell的行号
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    NSInteger row = indexPath.row;
    
    // 获得评论数据
    NSArray *comments = self.latestComments;
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    }
    
    return comments[row];
}

#pragma mark - UIMenuController处理
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

// 重写此方法，来控制 UIMenuItem 的显示和隐藏
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (!self.isFirstResponder) { // 文本框弹出键盘, 文本框才是第一响应者
        if (action == @selector(ding:)
            || action == @selector(reply:)
            || action == @selector(warn:)) return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (void)ding:(UIMenuController *)menu
{
    XQLog(@"ding - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}

- (void)reply:(UIMenuController *)menu
{
    XQLog(@"reply - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}

- (void)warn:(UIMenuController *)menu
{
    XQLog(@"warn - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}








@end
