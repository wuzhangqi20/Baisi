//
//  XQTopic.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/8.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQTopic.h"
#import "XQComment.h"
#import "XQUser.h"



@implementation XQTopic

- (NSString *)created_at{

//    _created_at = @"2017-02-09 18:30:00";
    
    NSString *created = _created_at;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *createDate = [fmt dateFromString:created];
    NSDate *nowDate = [NSDate date];
    NSDateComponents *intervarDaysCmps = [nowDate intervarFromDate:createDate];
    if (intervarDaysCmps.year != 0) {
        return [NSString stringWithFormat:@"%zd年前", intervarDaysCmps.year];
    } else if (intervarDaysCmps.month != 0) {
        return [NSString stringWithFormat:@"%zd月前", intervarDaysCmps.month];
    } else if ([createDate isToday]) {
        if (intervarDaysCmps.hour) {
            return [NSString stringWithFormat:@"%zd小时前", intervarDaysCmps.hour];
        } else if (intervarDaysCmps.minute) {
            return [NSString stringWithFormat:@"%zd分钟前", intervarDaysCmps.minute];
        } else {
            return @"刚刚";
        }
    } else if ([createDate isYesterday]) {
        fmt.dateFormat = @"HH:mm:ss";
        NSString *timeStr = [fmt stringFromDate:createDate];
        return [NSString stringWithFormat:@"昨天 %@", timeStr];
    }
    return [NSString stringWithFormat:@"%zd天前", intervarDaysCmps.day];
}

// 计算cell高度
- (CGFloat)cellHeight{
    
    if (_cellHeight) return _cellHeight;
    
    //_cellHeight = 0;
    _cellHeight += (10 + 35 + 10);
    
    
    // 计算文字的高度
    CGFloat textW = XQScreenW - XQCommonMargin * 2;
    CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    _cellHeight += textH + XQCommonMargin;
    
    // 判断类型
    if (self.type != XQTopicTypeWord) {
        CGFloat contentH = self.height * textW / self.width;
        if (contentH >= XQScreenH && !self.is_gif) {
            contentH = 200;
            self.bigPicture = YES;
        }
        
        CGFloat contentX = XQCommonMargin;
        CGFloat contentY = _cellHeight;
        self.contentFrame = CGRectMake(contentX, contentY, textW, contentH);
        _cellHeight += contentH + XQCommonMargin;
    }
    
    // 最热评论
    if (self.topComment) {
        NSString *username = self.topComment.user.username;
        NSString *content = self.topComment.content;
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
        // 评论内容的高度
        CGFloat cmtTextH = [cmtText boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        _cellHeight += (cmtTextH + XQCommonMargin);
    }
    
    _cellHeight += (35 + XQCommonMargin);
    return _cellHeight;
}

@end
