//
//  XQTopicCell.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/8.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQTopicCell.h"

#import "XQTopic.h"
#import "XQComment.h"
#import "XQUser.h"
#import <UIImageView+WebCache.h>
#import "XQTopicPictureView.h"
#import "XQTopicVideoView.h"
#import "XQTopicVoiceView.h"

@interface XQTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;

/** 图片 */
@property (nonatomic, weak) XQTopicPictureView *pictureView;
/** 视频 */
@property (nonatomic, weak) XQTopicVideoView *videoView;
/** 声音 */
@property (nonatomic, weak) XQTopicVoiceView *voiceView;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCmtViewH;

@end



@implementation XQTopicCell

// Assigning retained object to weak property object will be released after assignment
// 把retained对象赋值给弱引用，在赋值完毕之后会release。应该先将对象addsubview再赋值
- (XQTopicPictureView *)pictureView{
    if (!_pictureView) {
        XQTopicPictureView *pictureView = [XQTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (XQTopicVoiceView *)voiceView{
    if (!_voiceView) {
        XQTopicVoiceView *voiceView = [XQTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (XQTopicVideoView *)videoView{
    if (!_videoView) {
        XQTopicVideoView *videoView = [XQTopicVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]]];
}

- (void)setTopic:(XQTopic *)topic
{
    _topic = topic;
    
    [self.profileImageView xq_setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.createdAtLabel.text = topic.created_at;
    self.text_label.text = topic.text;
    
    // 设置底部工具条的数字
    [self setupButton:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButton:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButton:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButton:self.commentButton number:topic.comment placeholder:@"评论"];
    
    if (self.topic.type == XQTopicTypePicture) {
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.pictureView.hidden = NO;
        self.pictureView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.pictureView.frame = topic.contentFrame;
        self.pictureView.topic = self.topic;

    } else if (self.topic.type == XQTopicTypeVideo) {
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.pictureView.hidden = YES;
        self.videoView.frame = topic.contentFrame;
        self.videoView.topic = topic;

    } else if (self.topic.type == XQTopicTypeVoice) {
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
        self.voiceView.frame = topic.contentFrame;
        self.voiceView.topic = topic;
    } else if (self.topic.type == XQTopicTypeWord) {
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    if (self.topic.topComment) {
        self.topCmtView.hidden = NO;
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", self.topic.topComment.user.username, self.topic.topComment.content];
        CGFloat topCmtViewY = CGRectGetMaxY(self.topic.contentFrame) + XQCommonMargin;
        CGFloat topCmtViewH = self.topic.cellHeight - 35 - XQCommonMargin * 2 - topCmtViewY;
//        [self.topCmtView setFrame:CGRectMake(XQCommonMargin, topCmtViewY, XQScreenW - XQCommonMargin * 2, topCmtViewH)];
        self.topCmtViewH.constant = topCmtViewH;
    } else {
        self.topCmtView.hidden = YES;
    }
}

- (void)setupButton:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}
- (IBAction)moreClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        XQLog(@"收藏");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        XQLog(@"举报");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        XQLog(@"取消");
    }]];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= XQCommonMargin;
    [super setFrame:frame];
}

// 也可以监听cell点击
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    XQLogFunc
//    // Configure the view for the selected state
//}

@end
