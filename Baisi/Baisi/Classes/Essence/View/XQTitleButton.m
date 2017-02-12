//
//  XQTitleButton.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/24.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQTitleButton.h"

@implementation XQTitleButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

// 重写此方法废除点击高亮，避免闪烁
- (void)setHighlighted:(BOOL)highlighted{}

@end
