//
//  XQFriendTrendsViewController.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/2.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQFriendTrendsViewController.h"

#import "XQLoginRegisterViewController.h"

@interface XQFriendTrendsViewController ()

@end

@implementation XQFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XQColor(227, 227, 227);
}

- (IBAction)loginRegClick:(id)sender {
    
    XQLoginRegisterViewController *loginRegVC = [[XQLoginRegisterViewController alloc] init];
    [self presentViewController:loginRegVC animated:YES completion:nil];    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
