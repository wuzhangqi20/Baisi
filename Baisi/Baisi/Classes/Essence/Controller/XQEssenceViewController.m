//
//  XQEssenceViewController.m
//  Baisi
//
//  Created by 吴章琦 on 2016/12/29.
//  Copyright © 2016年 吴章琦. All rights reserved.
//

#import "XQEssenceViewController.h"

#import "XQTestViewController.h"

@interface XQEssenceViewController ()

@end

@implementation XQEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setupNav];
}

- (void)setupNav{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}
// 导航条左按钮点击
- (void)tagClick{
    XQLogFunc
    [self.navigationController pushViewController:[[XQTestViewController alloc] init] animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
