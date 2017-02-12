//
//  XQUser.h
//  Baisi
//
//  Created by 吴章琦 on 2017/2/9.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQUser : NSObject

/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;

@end
