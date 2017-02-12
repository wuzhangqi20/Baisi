//
//  NSCalendar+XQExtension.m
//  Baisi
//
//  Created by 吴章琦 on 2017/2/9.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "NSCalendar+XQExtension.h"

@implementation NSCalendar (XQExtension)

+ (instancetype)xq_calendar{

    if (iOS(8.0)) {
        return [self calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        return [self currentCalendar];
    }
}

@end
