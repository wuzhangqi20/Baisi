//
//  XQCommentCell.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/12.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQCommentCell.h"

#import "XQComment.h"
#import "XQUser.h"

@interface XQCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;


@end

@implementation XQCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setComment:(XQComment *)comment
{
    _comment = comment;
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }
    
    [self.profileImageView xq_setHeader:comment.user.profile_image];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    if ([comment.user.sex isEqualToString:XQUserSexMale]) {
        self.sexView.image = [UIImage imageNamed:@"Profile_manIcon"];
    } else {
        self.sexView.image = [UIImage imageNamed:@"Profile_womanIcon"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
