//
//  NSString+XQExtension.m
//  Baisi
//
//  Created by 吴章琦 on 2017/1/21.
//  Copyright © 2017年 吴章琦. All rights reserved.
//

#import "NSString+XQExtension.h"

@implementation NSString (XQExtension)

- (unsigned long long)fileSize{

    unsigned long long size = 0;
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 判断路径存不存在
    BOOL isDirectory = NO;
    
    BOOL isExist = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    if (!isExist) return 0;
    if (isDirectory) {
        // 此方法也可以遍历，content...方法不行，只能遍历一层文件夹
        //        NSArray *pathArr = [mgr subpathsAtPath:self];
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        for (NSString *path in enumerator) {
            NSString *fullPath = [self stringByAppendingPathComponent:path];
            // fileSize是NSDictionary分类的属性
            size += [mgr attributesOfItemAtPath:fullPath error:nil].fileSize;
        }
    } else{
        size = [mgr attributesOfItemAtPath:self error:nil].fileSize;
    }
    // 或者用如下方法判断路径是否存在
//    NSDictionary *attrs = [mgr attributesOfItemAtPath:self error:nil];
//    if (attrs[NSFileType] == NSFileTypeDirectory) {}
    
    return size;
}

@end
