//
//  XQTabBar.m
//  Baisi
//
//  Created by 吴章琦 on 2016/12/31.
//  Copyright © 2016年 吴章琦. All rights reserved.
//

#import "XQTabBar.h"


@interface XQTabBar ()

// 发布按钮
@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation XQTabBar

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [plusBtn sizeToFit];
        [plusBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

// plusBtn点击
- (void)publishClick{

}

- (void)layoutSubviews{

    [super layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    self.plusBtn.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 按钮索引
    int index = 0;
    NSInteger count = self.items.count + 1;
    CGFloat tabBarButtonW = width / count;
    CGFloat tabBarButtonH = height;
    CGFloat tabBarButtonY = 0;
    
    // 设置4个button的frame
    for (UIView *tabBarButton in self.subviews) {
        // 如果不是UITabBarButton，则结束单次循环。UITabBarButton是私有类
        if (![NSStringFromClass(tabBarButton.class) isEqualToString:@"UITabBarButton"]) continue;
        if (index == count / 2) {
            index += 1;
        }
        tabBarButton.frame = CGRectMake(tabBarButtonW * index, tabBarButtonY, tabBarButtonW, tabBarButtonH);
        index++;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
