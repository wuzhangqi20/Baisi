//
//  NSDate+XQExtension.h
//  Baisi
//
//  Created by 吴章琦 on 2017/2/9.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XQExtension)

- (BOOL)isToday;

- (BOOL)isYesterday;

- (NSDateComponents *)intervarFromDate:(NSDate *)date;

@end
