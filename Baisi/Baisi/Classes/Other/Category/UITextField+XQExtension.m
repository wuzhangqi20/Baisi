//
//  UITextField+XQExtension.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/11.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "UITextField+XQExtension.h"

static NSString * const XQPlaceholderColorKey = @"placeholderLabel.textColor";

@implementation UITextField (XQExtension)

- (void)setPlaceholderColor:(UIColor *)placeholderColor{

    // 因为placeholderLaber是懒加载，所以不管怎样先让它创建，再将原来的值赋给它
    NSString *oldPlaceholder = self.placeholder;
    self.placeholder = @" ";// 必须打一个空格让长度不为0
    self.placeholder = oldPlaceholder;
    
    // 如果将placeholderColor设置为空，则恢复默认颜色
    if (placeholderColor == nil) {
        placeholderColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    }
    
    // 设置占位文字颜色
    [self setValue:placeholderColor forKeyPath:XQPlaceholderColorKey];
}

- (UIColor *)placeholderColor{
    return [self valueForKeyPath:XQPlaceholderColorKey];
}

@end
