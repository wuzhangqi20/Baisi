//
//  UIBarButtonItem+XQExtension.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/3.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "UIBarButtonItem+XQExtension.h"

@implementation UIBarButtonItem (XQExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    //
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:btn];
    
}

@end
