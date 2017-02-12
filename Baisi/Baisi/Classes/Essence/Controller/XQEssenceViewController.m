//
//  XQEssenceViewController.m
//  Baisi
//
//  Created by 吴章琦 on 2016/12/29.
//  Copyright © 2016年 吴章琦. All rights reserved.
//

#import "XQEssenceViewController.h"
#import "XQAllViewController.h"
#import "XQVideoViewController.h"
#import "XQPictureViewController.h"
#import "XQVoiceViewController.h"
#import "XQWordViewController.h"
#import "XQTitleButton.h"

@interface XQEssenceViewController () <UIScrollViewDelegate>

/** 标题栏底部的指示器 */
@property (nonatomic, weak) UIView *indicator;
@property (nonatomic, weak) XQTitleButton *selectedTitleButton;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titleBtns;
@property (nonatomic, assign) double titleSelectedIndex;

@end

@implementation XQEssenceViewController

- (NSMutableArray *)titleBtns{
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setupNav];
    
    // 设置子控制器
    [self setupChildVCs];
    
    // 设置scrollView
    [self setupScrollView];
    
    // 设置titlesView
    [self setupTitlesView];
}

- (void)setupNav{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}
// 导航条左按钮点击
- (void)tagClick{
    XQLogFunc
    
}

- (void)setupChildVCs{
    XQAllViewController *allVC = [[XQAllViewController alloc] init];
    allVC.title = @"全部";
    [self addChildViewController:allVC];
    
    XQVideoViewController *videoVC = [[XQVideoViewController alloc] init];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    
    XQPictureViewController *pictureVC = [[XQPictureViewController alloc] init];
    pictureVC.title = @"图片";
    [self addChildViewController:pictureVC];
    
    XQVoiceViewController *voiceVC = [[XQVoiceViewController alloc] init];
    voiceVC.title = @"声音";
    [self addChildViewController:voiceVC];
    
    XQWordViewController *wordVC = [[XQWordViewController alloc] init];
    wordVC.title = @"段子";
    [self addChildViewController:wordVC];
}

- (void)setupScrollView{
    // 如果第一个子控件是scrollView会自动往下移动64.设置为NO禁止自动下移
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = XQColor(215, 215, 215);
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
//    XQLog(@"%@--%@", NSStringFromCGRect(scrollView.frame), NSStringFromCGSize(scrollView.contentSize));
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    // 将scrollView的offset设置不为0，这样初始化setContentOffset方法时就会产生动画，就会进入代理方法scrollViewDidEndScrollingAnimation:
    scrollView.contentOffset = CGPointMake(414, 0);
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    
}

- (void)setupTitlesView{

    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    titlesView.frame = CGRectMake(0, 64, self.view.width, 35);
    [self.view addSubview:titlesView];
    
    // 设置titlesView的按钮
    NSUInteger count = self.childViewControllers.count;
    CGFloat buttonW = titlesView.width / count;
    CGFloat buttonH = titlesView.height;
    
    
    for (int i = 0; i < count; i++) {
        XQTitleButton *btn = [XQTitleButton buttonWithType:UIButtonTypeCustom];
        // 文字
        NSString *btnTitle = self.childViewControllers[i].title;
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        
        // 监听点击
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // frame
        btn.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
        [titlesView addSubview:btn];
        [self.titleBtns addObject:btn];
    }
    
    // 标签栏底部的指示器控件
    UIView *indicator = [[UIView alloc] init];
    XQTitleButton *firstBtn = [[titlesView subviews] firstObject];
    indicator.backgroundColor = [firstBtn titleColorForState:UIControlStateSelected];
    indicator.height = 1;
    indicator.y = titlesView.height - indicator.height;
    self.indicator = indicator;
    [titlesView addSubview:indicator];
    
    // 默认点击第一个按钮
    // 先sizeTiFit把titleLabel的size算出来，再将它的宽度赋值给indicator
    [firstBtn.titleLabel sizeToFit];
    self.indicator.width = firstBtn.titleLabel.width;
    self.indicator.centerX = firstBtn.centerX;
    [self titleClick:firstBtn];
}

- (void)titleClick:(XQTitleButton *)btn{
    
    // 设置点击按钮的选中状态
    self.selectedTitleButton.selected = NO;
    btn.selected = YES;
    self.selectedTitleButton = btn;

    // indicator的动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicator.width = btn.titleLabel.width;
        self.indicator.centerX = btn.centerX;
    }];
    
    // scrollView 的偏移
    CGPoint offset = self.scrollView.contentOffset;
    
    offset.x = btn.x / btn.width * self.view.width;
    
    [self.scrollView setContentOffset:offset animated:YES];
    
    if (btn.x / btn.width == self.titleSelectedIndex) {
//    if (btn == self.selectedTitleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XQTitleButtonDidRepeatClickNotification object:nil];
    }
    // 如果将titleSelectedIndex声明为NSInteger，则有问题。只能为0，2，4
    self.titleSelectedIndex = btn.x / btn.width;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    int index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *expectVC = self.childViewControllers[index];
    
//    if ([expectVC isViewLoaded]) return;
    
    // 将期望显示的VC的view添加到scrollView
    expectVC.view.frame = scrollView.bounds;
//    XQLog(@"zj%@", NSStringFromCGRect(expectVC.view.frame));
    [scrollView addSubview:expectVC.view];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    int index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titleBtns[index]];
    
}

@end
