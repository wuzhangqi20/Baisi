//
//  UIView+XQExtension.h
//  Baisi
//
//  Created by 吴章琦 on 2017/1/1.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XQExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

+ (instancetype)viewFromXib;

- (BOOL)xq_isIntersectsRect:(UIView *)view;

@end
