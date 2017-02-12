//
//  XQTopicPictureView.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/11.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQTopicPictureView.h"
#import <DALabeledCircularProgressView.h>
#import <UIImageView+WebCache.h>
#import "XQTopic.h"
#import "XQSeeBigPictureViewController.h"

@interface XQTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;


@end
@implementation XQTopicPictureView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
    
    self.pictureView.userInteractionEnabled = YES;
    
    // 清空自动伸缩
    self.pictureView.autoresizingMask = UIViewAutoresizingNone;
    [self.pictureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)]];
    
}

- (void)imageClick{
    XQLogFunc
    if (self.pictureView.image == nil) return;
    XQSeeBigPictureViewController *seeBigVC = [[XQSeeBigPictureViewController alloc] init];
    seeBigVC.topic = self.topic;
    [self.window.rootViewController presentViewController:seeBigVC animated:YES completion:nil];
}

- (void)setTopic:(XQTopic *)topic
{
    _topic = topic;
    XQWeakSelf
   
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = 1.0 *receivedSize / expectedSize;
        weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", weakSelf.progressView.progress * 100];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.progressView.hidden = YES;
    }];
    // 显示gif图标
    self.gifView.hidden = !topic.is_gif;
    
    // 是否大图
    self.seeBigButton.hidden = !topic.isBigPicture;
    if (topic.isBigPicture) {
        self.pictureView.contentMode = UIViewContentModeTop;
        self.pictureView.clipsToBounds = YES;
    } else{
        self.pictureView.contentMode = UIViewContentModeScaleToFill;
        self.pictureView.clipsToBounds = NO;
    }
    
}

@end
