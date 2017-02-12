//
//  XQTopicViewController.h
//  Baisi
//
//  Created by 吴章琦 on 2017/1/24.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQTopic.h"

@interface XQTopicViewController : UITableViewController

// 只写get方法是为了避免外界修改
- (XQTopicType)type;

@end
