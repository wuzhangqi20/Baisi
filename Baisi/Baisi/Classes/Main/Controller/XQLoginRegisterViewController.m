//
//  XQLoginRegisterViewController.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/4.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQLoginRegisterViewController.h"

@interface XQLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginboxLeftMargin;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation XQLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置登录注册按钮的圆角
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.layer.masksToBounds = YES;
}
- (IBAction)showLoginOrRegister:(UIButton *)sender {
    if (self.loginboxLeftMargin.constant) {
        self.loginboxLeftMargin.constant = 0;
    }else{
        self.loginboxLeftMargin.constant = self.view.width;
    }
    
    // 需要强制刷新，因为上面改变常量值需要刷新应用
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];    
}
// 关闭登录注册页面
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setEditing:NO];
}

// 设置弹出登录界面时的状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
