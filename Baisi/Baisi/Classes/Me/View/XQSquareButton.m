//
//  XQSquareButton.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/19.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQSquareButton.h"
#import "XQSquare.h"
#import <UIButton+WebCache.h>

@implementation XQSquareButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.y = self.height * 0.1;
    // 不能用self.centerX,因为它是相对父控件的
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

- (void)setSquare:(XQSquare *)square{

    _square = square;
    // 设置数据
    [self setTitle:square.name forState:UIControlStateNormal];
    
    // 设置图片
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}

@end
