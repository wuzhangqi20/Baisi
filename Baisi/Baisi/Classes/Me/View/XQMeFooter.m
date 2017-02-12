//
//  XQMeFooter.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/11.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQMeFooter.h"
#import <AFNetWorking.h>
#import "XQSquare.h"
#import "XQSquareButton.h"
#import <MJExtension.h>
#import "XQWebViewController.h"

@implementation XQMeFooter

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        // 请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        XQWeakSelf
        // 发送请求
        [[AFHTTPSessionManager manager] GET:XQRequestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf createSquares:[XQSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            XQLog(@"请求出错");
        }];
    }
    return self;
}

- (void)createSquares:(NSArray *)squares{
    
    // 每行的列数
    int colsCount = 4;
    
    // 按钮尺寸
    CGFloat buttonW = self.width / colsCount;
    CGFloat buttonH = buttonW;
    
    // 遍历所有的模型
    NSUInteger count = squares.count;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建按钮
        XQSquareButton *btn = [XQSquareButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        // 设置frame
        CGFloat buttonX = (i % colsCount) * buttonW;
        CGFloat buttonY = (i / colsCount) * buttonH;
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 设置square
        btn.square = squares[i];
        
        // 设置footer高度
        self.height = CGRectGetMaxY(btn.frame);
    }
    
    // 重新设置footerView
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
    
}

- (void)btnClick:(XQSquareButton *)btn{
    if (![btn.square.url hasPrefix:@"http"]) return;
    XQWebViewController *webVC = [[XQWebViewController alloc] init];
    // 重要的一步
    webVC.square = btn.square;
    UITabBarController *tabBarVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController *navVC = (UINavigationController *)tabBarVC.selectedViewController;
    [navVC pushViewController:webVC animated:YES];
}

@end









