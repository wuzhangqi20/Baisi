//
//  XQTopicVideoView.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/11.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQTopicVideoView.h"
#import <UIImageView+AFNetworking.h>
#import "XQTopic.h"
@interface XQTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *palyButton;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;

@end

@implementation XQTopicVideoView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)setTopic:(XQTopic *)topic{
    _topic = topic;
    [_videoView setImageWithURL:[NSURL URLWithString:topic.large_image]];
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    // %02zd ：显示这个数字需要占据2位空间，不足的空间用0替补
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end
