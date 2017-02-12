//
//  XQLoginRegisterTextField.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/5.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "XQLoginRegisterTextField.h"

// 运行时runtime
#import <objc/runtime.h>

static NSString * const XQPlaceholderColorKey = @"placeholderLabel.textColor";

@interface XQLoginRegisterTextField ()

@property (nonatomic, strong) id observer;

@end

@implementation XQLoginRegisterTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [self setup];
    [super awakeFromNib];
}

- (void)setup{
//    // 遍历UILabel内部的子元素
//    unsigned int count;
//    Ivar *ivarList = class_copyIvarList([UITextField class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = ivarList[i];
//        XQLog(@"%s", ivar_getName(ivar));
//    }
//    free(ivarList);
//    
//    // 知道那个私有类之后用KVC取出设置，placeholderLabel前加不加_都可以
//    UILabel *label = [self valueForKeyPath:@"placeholderLabel"];
//    label.textColor = [UIColor whiteColor];
    //或者一句话
//    [self setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
    
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = XQColor(55, 55, 55);
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributes];
    
    // 或者通过range来设置某几个字的颜色
    // 图文混排
    // 用NSMutableAttributeString添加NSAttributeString
    // 下面这个方法用attachment附件初始化可以加载图片表情什么的
//    NSAttributedString attributedStringWithAttachment:<#(nonnull NSTextAttachment *)#>
    
    // 设置占位颜色第三种方法
    // 重写drawPlaceholderInRect
    
    //利用通知来监听点击事件，自己（第二个self）发出了通知调用自己(第一个self,监听器)的sel方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UITextFieldTextDidEndEditingNotification object:self];
    // 如果是用这个方法，需要将返回值作为监听器在dealloc中移除
//    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        
//    }];
}

- (void)dealloc{
    // 移除的是第一个self，监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}

- (void)beginEditing{
    [self setValue:[UIColor whiteColor] forKeyPath:XQPlaceholderColorKey];
}

- (void)endEditing{
    [self setValue:XQColor(55, 55, 55) forKeyPath:XQPlaceholderColorKey];
}

@end
