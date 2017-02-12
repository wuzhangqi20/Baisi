//
//  XQTopWindow.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/11.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQTopWindow.h"

static UIWindow *window_;

@implementation XQTopWindow

+ (void)show {

    // 如果不加after，在这个方法结束时添加的window必须有个根控制器，不然会报错
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        window_ = [[UIWindow alloc] init];
        window_.frame = [UIApplication sharedApplication].statusBarFrame;
        window_.backgroundColor = [UIColor clearColor];
        window_.windowLevel = UIWindowLevelAlert;
        window_.hidden = NO;
        [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusBarClick)] ];
    });
}

+ (void)statusBarClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self findAndScrollView:window];
}

// 遍历所有子控件并将符合要求的控件回到顶部
+ (void)findAndScrollView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        [self findAndScrollView:subview];
    }
    //    XQLog(@"%@", view.class);
    // 如果不是UIScrollView就return
    if (![view isKindOfClass:[UIScrollView class]]) return;
    
    UIScrollView *scrollView = (UIScrollView *)view;
    // 如果不是跟当前主window不重叠就return
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (![window xq_isIntersectsRect:scrollView]) return;
    
    // 执行向上滚动操作
    CGPoint offset = scrollView.contentOffset;
    offset.y = - scrollView.contentInset.top;
    [scrollView setContentOffset:offset animated:YES];
}

@end
