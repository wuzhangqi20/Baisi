//
//  XQClearCacheCell.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/20.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQClearCacheCell.h"
#import <SVProgressHUD.h>
#import <SDImageCache.h>

#define XQCachePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Custom"]

@implementation XQClearCacheCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.text = @"清除缓存(正在计算缓存大小...)";
        // 禁止点击事件，需放在设置文字后，不然会是灰色
        self.userInteractionEnabled = NO;
        // 设置转圈动画
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;
        

        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            XQLog(@"%@", cachePath);
            NSString *fullPath = [cachePath stringByAppendingPathComponent:@"Custom"];
            XQLog(@"%@", fullPath);
            
            XQWeakSelf
            unsigned long long size = fullPath.fileSize;
            size += [SDImageCache sharedImageCache].getSize;
            
            // 如果用户退出，控制器已经销毁，则不需要执行以下代码
            if (!weakSelf) return;

            NSString *sizeText = @"";
            if (size > pow(10, 9)) {
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size > pow(10, 6)){
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            } else if (size > pow(10, 3)){
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else {
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.userInteractionEnabled = YES;
                weakSelf.accessoryView = nil;
                weakSelf.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                weakSelf.textLabel.text = [NSString stringWithFormat:@"清除缓存(%@)", sizeText];
            });
            
            // 添加手势监听器

        });
    }
    
    return self;

}

// 更新右边的加载视图
- (void)updateStatus{
    if (!self.accessoryView) return;
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
}

// 清除缓存
- (void)clearCache{
    [SVProgressHUD showWithStatus:@"正在清除缓存..."];

    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
       // 删除SDImageCache之后，再删除自定义的
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSFileManager *mgr = [NSFileManager defaultManager];
            // 删除
            [mgr removeItemAtPath:XQCachePath error:nil];
            // 创建,YES表示会自动创建路径中间不存在的目录
            [mgr createDirectoryAtPath:XQCachePath withIntermediateDirectories:YES attributes:nil error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                self.textLabel.text = @"清除缓存(0B)";
                self.userInteractionEnabled = NO;
            });
        });
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
