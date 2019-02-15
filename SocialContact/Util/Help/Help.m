//
//  Help.m
//  SocialContact
//
//  Created by EDZ on 2019/1/24.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Help.h"

@implementation Help

//在最大压缩条件下,文件小于 maxFileSize
+ (NSData *)compressImage:(UIImage *)image{
    NSInteger maxFileSize = 60;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"compressImage:original:%f kb",imageData.length/1024.0);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"compressImage:compress:%f kb",imageData.length/1024.0);
    return imageData;
}

+ (NSString *)profession:(NSInteger)professionType{
    NSString *str;
    switch (professionType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"事业单位";
            break;
        case 2:
            str = @"政府机关";
            break;
        case 3:
            str = @"私营企业";
            break;
        case 4:
            str = @"自由职业";
            break;
        case 5:
            str = @"其他";
            break;
        default:
            break;
    }
    return str;
}

// 教育
+ (NSString *)education:(NSInteger)educationType{
    NSString *str;
    switch (educationType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"初中";
            break;
        case 2:
            str = @"高中";
            break;
        case 3:
            str = @"中专";
            break;
        case 4:
            str = @"大专";
            break;
        case 5:
            str = @"本科";
            break;
        case 6:
            str = @"硕士";
            break;
        case 7:
            str = @"博士";
            break;
        case 8:
            str = @"院士";
            break;
        default:
            break;
    }
    return str;
}

// 收入
+ (NSString *)income:(NSInteger)incomeType{
//    (0, '未知'),
//    (1, '10万以下'),
//    (2, '10万~20万'),
//    (3, '20万~50万'),
//    (4, '50万以上'),
//    )
    NSString *str;
    switch (incomeType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"10万以下";
            break;
        case 2:
            str = @"10万~20万";
            break;
        case 3:
            str = @"20万~50万";
            break;
        case 4:
            str = @"50万以上";
            break;
        default:
            break;
    }
    return str;
}

// 婚姻状态
+ (NSString *)marital_status:(NSInteger)marital_statusType{
    
//    MARITAL_STATUS_CHOICE = (
//                             (0, '未知'),
//                             (1, '未婚'),
//                             (2, '离异'),
//                             (3, '丧偶'),
//                             )
    NSString *str;
    switch (marital_statusType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"未婚";
            break;
        case 2:
            str = @"离异";
            break;
        case 3:
            str = @"丧偶";
            break;
        default:
            break;
    }
    return str;
    
}

// 小孩状态
+ (NSString *)child_status:(NSInteger)child_statusType{
//    CHILD_STATUS_CHOICE = (
//                           (0, '未知'),
//                           (1, '无'),
//                           (2, '有，和我在一起'),
//                           (3, '有，不和我在一起'),
//                           )
    NSString *str;
    switch (child_statusType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"无";
            break;
        case 2:
            str = @"有，和我在一起";
            break;
        case 3:
            str = @"有，不和我在一起";
            break;
        default:
            break;
    }
    return str;
}

// 小孩状态
+ (NSString *)yearsToMarial:(NSInteger)yearsToMarialType{
    //    CHILD_STATUS_CHOICE = (
    //                           (0, '未知'),
    //                           (1, '无'),
    //                           (2, '有，和我在一起'),
    //                           (3, '有，不和我在一起'),
    //                           )
    NSString *str;
    switch (yearsToMarialType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"1年内";
            break;
        case 2:
            str = @"1-2年内";
            break;
        case 3:
            str = @"2-3年内";
            break;
        case 4:
            str = @"3年以上";
            break;
        default:
            break;
    }
    return str;
}

@end