//
//  XQNavigationController.m
//  Baisi
//
//  Created by 吴章琦 on 2016/12/29.
//  Copyright © 2016年 吴章琦. All rights reserved.
//

#import "XQNavigationController.h"

@interface XQNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation XQNavigationController

// 不一定只调用一次，子类初始化的时候也会调用，可用load
//+ (void)initialize{
//    if (self == [当前类名 class]) {
//        ...
//    }
//}

// 类加载的时候初始化，只做一次
+ (void)load{
    // 获得自定义XQNavigation的navigationBar的外观
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[XQNavigationController class]]];
    // 设置背景
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    // 设置标题文字属性
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    barAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:barAttrs];
    // 设置barButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[XQNavigationController class]]];
    // UIControlStateNormal
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    barAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    barAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
    barAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 指定代理，不然系统返回手势失效
    self.interactivePopGestureRecognizer.delegate = self;
}

// 拦截所有push的控制器，给他们统一返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.childViewControllers.count >= 1) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backBtn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backBtn sizeToFit];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        // 左移20
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        // 隐藏底部的工具条，如果失效，则在xib或者storyBoard中勾选Hide bottom bar on push
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 一定要写在最后面
    [super pushViewController:viewController animated:animated];
}

- (void)backClick{
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
// 设置在第一个控制器的时候禁用手势识别，不然会有卡死BUG
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count > 1;
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
