//
//  XQMeCell.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/11.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQMeCell.h"

@implementation XQMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    if (!self.imageView) return;
    self.imageView.y = XQCommonMargin * 0.5;
    self.imageView.height = self.contentView.height - XQCommonMargin;
    self.imageView.width = self.imageView.height;
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + XQCommonMargin;
}

@end
