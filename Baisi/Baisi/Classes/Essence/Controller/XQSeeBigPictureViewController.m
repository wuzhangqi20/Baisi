//
//  XQSeeBigPictureViewController.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/11.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQSeeBigPictureViewController.h"
#import "XQTopic.h"

#import <UIImageView+WebCache.h>

@interface XQSeeBigPictureViewController ()

@end

@implementation XQSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)gobackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
}

- (void)setTopic:(XQTopic *)topic{
    _topic = topic;
    UIImageView *imageView = [[UIImageView alloc] init];
    XQLog(@"%@", topic.large_image);
    [imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    imageView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:imageView];
}



@end
