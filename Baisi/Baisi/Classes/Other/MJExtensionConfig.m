//
//  MJExtensionConfig.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/9.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "MJExtensionConfig.h"
#import <MJExtension.h>
#import "XQTopic.h"
#import "XQComment.h"

@implementation MJExtensionConfig

+ (void)load{
    [XQTopic mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"small_image" : @"image0",
                 @"middle_image" : @"image2",
                 @"large_image" : @"image1",
                 @"topComment" : @"top_cmt[0]"
                 };
    }];
    
    [XQComment mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}

@end
