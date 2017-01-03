//
//  XQTabBarController.m
//  Baisi
//
//  Created by 吴章琦 on 2016/12/29.
//  Copyright © 2016年 吴章琦. All rights reserved.
//

#import "XQTabBarController.h"

#import "XQNavigationController.h"

#import "XQEssenceViewController.h"
#import "XQNewViewController.h"
#import "XQFriendTrendsViewController.h"
#import "XQMeViewController.h"
#import "XQTabBar.h"

@interface XQTabBarController ()

@end

@implementation XQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupItem];
    
    [self setupAllChildVCs];
    
    // 设置自定义的tabBar
    [self setupTabBar];
}

- (void)setupTabBar{
    [self setValue:[[XQTabBar alloc] init] forKeyPath:@"tabBar"];
}

// 设置所有子控制器
- (void)setupAllChildVCs{
    
    [self setupChildVC:[[XQEssenceViewController alloc] init] image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon" title:@"精华"];
    [self setupChildVC:[[XQNewViewController alloc] init] image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon" title:@"新帖"];
    [self setupChildVC:[[XQFriendTrendsViewController alloc] init] image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon" title:@"关注"];
    [self setupChildVC:[[XQMeViewController alloc] init] image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon" title:@"我"];
    
}

// 设置子控制器
- (void)setupChildVC:(UIViewController *)vc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title{
    // 创建并包装自定义的navigationController
//    vc.view.backgroundColor = XQRandomColor;
    XQNavigationController *nv = [[XQNavigationController alloc] initWithRootViewController:vc];
    nv.tabBarItem.title = title;
    [nv.tabBarItem setImage:[UIImage imageNamed:image]];
    // 设置tabBarItem的图片渲染不按系统默认蓝色进行，好像在assets右边属性栏改变图片的renderAs没用
    UIImage *selectedImg = [UIImage imageNamed:selectedImage];
    selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nv.tabBarItem setSelectedImage:selectedImg];
    [self addChildViewController:nv];
}

// 统一设置UITabBarItem的文字样式
- (void)setupItem
{
    // 设置正常状态的样式
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // 选中状态下的样式
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}


@end
