//
//  XQTopic.h
//  Baisi
//
//  Created by 吴章琦 on 2017/2/8.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XQComment;

typedef enum {
    /** 全部 */
    XQTopicTypeAll = 1,
    
    /** 图片 */
    XQTopicTypePicture = 10,
    
    /** 段子(文字) */
    XQTopicTypeWord = 29,
    
    /** 声音 */
    XQTopicTypeVoice = 31,
    
    /** 视频 */
    XQTopicTypeVideo = 41

} XQTopicType;

@interface XQTopic : NSObject
/** id */
@property (nonatomic, copy) NSString *ID; // id
// 用户 -- 发帖者
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 类型 */
@property (nonatomic, assign) XQTopicType type;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;

/** 小图 */
@property (nonatomic, copy) NSString *small_image; // image0
/** 大图 */
@property (nonatomic, copy) NSString *large_image; // image1
/** 中图 */
@property (nonatomic, copy) NSString *middle_image; // image2

/** 是否为动态图 */
@property (nonatomic, assign) BOOL is_gif;

/** 视频的时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 播放数量 */
@property (nonatomic, assign) NSInteger playcount;

/** 最热评论 */
@property (nonatomic, strong) XQComment *topComment;

/***** 额外增加的属性 ******/
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect contentFrame;
/** 是否大图片 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;
@end
