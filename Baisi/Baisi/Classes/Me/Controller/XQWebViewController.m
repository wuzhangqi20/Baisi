//
//  XQWebViewController.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/20.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQWebViewController.h"

#import "XQSquare.h"

@interface XQWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XQWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    self.title = self.square.name;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.square.url]]];
    self.webView.backgroundColor = XQColor(215, 215, 215);
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goback:(UIBarButtonItem *)sender {
    [self.webView goBack];
}
- (IBAction)goforward:(UIBarButtonItem *)sender {
    [self.webView goForward];
}
- (IBAction)refresh:(UIBarButtonItem *)sender {
    [self.webView reload];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    self.leftBtn.enabled = self.webView.canGoBack;
    self.rightBtn.enabled = self.webView.canGoForward;
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
