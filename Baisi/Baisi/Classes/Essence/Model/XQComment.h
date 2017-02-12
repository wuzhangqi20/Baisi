//
//  XQComment.h
//  Baisi
//
//  Created by 吴章琦 on 2017/2/8.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import <Foundation/Foundation.h>


@class XQUser;

@interface XQComment : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;

/** 文字内容 */
@property (nonatomic, copy) NSString *content;

/** 用户 */
@property (nonatomic, strong) XQUser *user;

/** 点赞数 */
@property (nonatomic, assign) NSInteger like_count;

/** 语音文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;

/** 语音文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;

@end
