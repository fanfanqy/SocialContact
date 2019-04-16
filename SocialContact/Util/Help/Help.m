//
//  Help.m
//  SocialContact
//
//  Created by EDZ on 2019/1/24.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Help.h"
#import "ProductModel.h"

@implementation Help

+ (BOOL)canPerformLoadRequest:(id)responseObject{
    if ([NSString ins_String:responseObject[@"data"][@"next"]]) {
        return YES;
    }
    return NO;
}

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

+ (void)vipIsExpired:(VipIsExpired)completion topIsExpired:(VipIsExpired)topExpiredCompletion {
//    /api/virtual-services/mine/
    
    GETRequest *request = [GETRequest requestWithPath:@"/api/virtual-services/mine/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
            if(completion){
                completion(YES);
            }
            if (topExpiredCompletion) {
                topExpiredCompletion(YES);
            }
            
            
        }else{
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
            NSMutableArray *array = [NSMutableArray array];
            
            if ( resultArray && resultArray.count > 0 ) {
                
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ProductModel *productModel = [ProductModel modelWithDictionary:obj];
                    [array addObject:productModel];
                    
                }];
                
                for (ProductModel *model in array) {
                    if(completion){
                        if (!model.expired && model.virtual_service.service_type == 1) {
                            completion(NO);
                            return ;
                        }
                    }
                
                    if (topExpiredCompletion) {
                        if (!model.expired && model.virtual_service.service_type == 2) {
                            completion(NO);
                            return ;
                        }
                    }
                }
                
                if(completion){
                    completion(YES);
                }
                if (topExpiredCompletion) {
                    completion(YES);
                }
                
            }else{
                if(completion){
                    completion(YES);
                }
                if (topExpiredCompletion) {
                    topExpiredCompletion(YES);
                }
            }
        }
    }];
    [InsNetwork addRequest:request];
    
    
}

+ (NSString *)gender:(NSInteger)gender{
    NSString *str = @"未知";
    if (gender == 1) {
        str = @"男";
    }else if (gender == 2) {
        str = @"女";
    }
    return str;
}

+ (NSString *)height:(CGFloat)height{
    NSString *str = @"165cm";
    if (height<1) {
        return str;
    }else{
        return [NSString stringWithFormat:@"%.1lfcm",height];
    }
    return str;
}

+ (NSString *)age:(NSInteger)age{
    NSString *str = @"-";
    if (age<1) {
        return str;
    }else{
        return [NSString stringWithFormat:@"%ld岁",age];
    }
    return str;
}

+ (NSString *)profession:(NSInteger)professionType{
    
    NSString *str = @"";
    switch (professionType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"学生";
            break;
        case 2:
            str = @"一般私有企业";
            break;
        case 3:
            str = @"个体户私有业主";
            break;
        case 4:
            str = @"事业单位";
            break;
        case 5:
            str = @"公务员";
            break;
        case 6:
            str = @"医疗机构";
            break;
        case 7:
            str = @"暂时无业";
            break;
        default:
            break;
    }
    return str;
}

// 教育
+ (NSString *)education:(NSInteger)educationType{
    NSString *str = @"";
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
//    (0, '--'),
//    (1, '10万以下'),
//    (2, '10万~20万'),
//    (3, '20万~50万'),
//    (4, '50万以上'),
//    )
    NSString *str = @"";
    switch (incomeType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"5000以下/月";
            break;
        case 2:
            str = @"5000-10000/月";
            break;
        case 3:
            str = @"10000-15000/月";
            break;
        case 4:
            str = @"15000以上/月";
            break;
        default:
            break;
    }
    return str;
}

// 婚姻状态
+ (NSString *)marital_status:(NSInteger)marital_statusType{
    
//    MARITAL_STATUS_CHOICE = (
//                             (0, '--'),
//                             (1, '未婚'),
//                             (2, '离异'),
//                             (3, '丧偶'),
//                             )
    NSString *str = @"";
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
//                           (0, '--'),
//                           (1, '无'),
//                           (2, '有，和我在一起'),
//                           (3, '有，不和我在一起'),
//                           )
    NSString *str=@"";
    switch (child_statusType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"无子女";
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


+ (NSString *)yearsToMarial:(NSInteger)yearsToMarialType{
    
    NSString *str = @"";
    switch (yearsToMarialType) {
        case 0:
            str = @"未知";
            break;
        case 1:
            str = @"1年内结婚";
            break;
        case 2:
            str = @"1-2年内结婚";
            break;
        case 3:
            str = @"2-3年内结婚";
            break;
        case 4:
            str = @"3年以上结婚";
            break;
        default:
            break;
    }
    return str;
}

@end
