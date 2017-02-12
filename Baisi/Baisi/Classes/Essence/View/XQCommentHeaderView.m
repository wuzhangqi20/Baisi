//
//  XQCommentHeaderView.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/12.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQCommentHeaderView.h"

@interface XQCommentHeaderView ()
/** 内部的label */
@property (nonatomic, weak) UILabel *label;
@end

@implementation XQCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = XQColor(215, 215, 215);
        
        // label
        UILabel *label = [[UILabel alloc] init];
        label.x = XQCommonMargin * 0.5;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textColor = XQColor(120, 120, 120);
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setText:(NSString *)text{

    _text = [text copy];
    self.label.text = text;
}

@end
