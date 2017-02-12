//
//  XQCommentViewController.h
//  Baisi
//
//  Created by 吴章琦 on 2017/2/12.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQTopic;

@interface XQCommentViewController : UIViewController

/** 帖子模型 */
@property (nonatomic, strong) XQTopic *topic;

@end
