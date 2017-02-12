//
//  UIImageView+XQExtension.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/8.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "UIImageView+XQExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (XQExtension)

- (void)xq_setHeader:(NSString *)url
{
    [self xq_setCircleHeader:url];
}

- (void)xq_setRectHeader:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

- (void)xq_setCircleHeader:(NSString *)url
{
    XQWeakSelf
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        weakSelf.image = [image circleImage];
    }];
}
@end
