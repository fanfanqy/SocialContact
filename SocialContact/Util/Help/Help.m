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
    NSString *str = @"未填写";
    if (gender == 1) {
        str = @"男";
    }else if (gender == 2) {
        str = @"女";
    }
    return str;
}

+ (NSString *)height:(CGFloat)height{
    NSString *str = @"未填写";
    if (height<1) {
        return str;
    }else{
        return [NSString stringWithFormat:@"%.1lfcm",height];
    }
    return str;
}

+ (NSString *)car:(NSInteger)car{
    NSString *str = @"保密";
    if (car == 1) {
        str = @"已购车辆";
    }else if (car == 2) {
        str = @"未购车辆";
    }
    return str;
}

+ (NSString *)house:(NSInteger)house{
    NSString *str = @"保密";
    if (house == 1) {
        str = @"已购车辆";
    }else if (house == 2) {
        str = @"未购车辆";
    }
    return str;
}



+ (NSString *)age:(NSInteger)age{
    NSString *str = @"未知";
    if (age<1) {
        return str;
    }else{
        return [NSString stringWithFormat:@"%ld岁",(long)age];
    }
    return str;
}
/*
PROFESSION_CHOICE = (
                     (0, '未知'),
                     (1, '白领/一般职业'),
                     (2, '公务员/事业单位'),
                     (3, '自由职业/个体户/私营业主'),
                     (4, '暂时无业'),
                     (5, '退休'),
                     (6, '学生'),
                     )
*/

+ (NSString *)profession:(NSInteger)professionType{
    
    NSString *str = @"";
    switch (professionType) {
        case 0:
            str = @"未填写";
            break;
        case 1:
            str = @"白领/一般职业";
            break;
        case 2:
            str = @"公务员/事业单位";
            break;
        case 3:
            str = @"自由职业/私营业主";
            break;
        case 4:
            str = @"暂时无业";
            break;
        case 5:
            str = @"公务员";
            break;
        case 6:
            str = @"退休";
            break;
        case 7:
            str = @"学生";
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
            str = @"未填写";
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
            str = @"未填写";
            break;
        case 1:
            str = @"5000以下";
            break;
        case 2:
            str = @"5000-1万";
            break;
        case 3:
            str = @"1万-15000";
            break;
        case 4:
            str = @"2万以上";
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
            str = @"未填写";
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
            str = @"未填写";
            break;
        case 1:
            str = @"无子女";
            break;
        case 2:
            str = @"有子女，和我在一起";
            break;
        case 3:
            str = @"有子女，不和我在一起";
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
            str = @"未填写";
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
            str = @"3年以后结婚";
            break;
        default:
            break;
    }
    return str;
}

+ (BOOL)checkFillAllInfo:(SCUserInfo *)userModel ignoreAvatar:(BOOL)ignoreAvatar{
    
    if (![NSString ins_String:userModel.avatar_url] && !ignoreAvatar) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"头像未设置，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (![NSString ins_String:userModel.name]) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"昵称未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (![NSString ins_String:userModel.intro]) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"自我介绍未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (userModel.gender == 0) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"性别未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (![NSString ins_String:userModel.birthday]) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"选择出生日期，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (userModel.height == 0) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"身高未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (![NSString ins_String:userModel.address_home]) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"家庭地址未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (![NSString ins_String:userModel.address_company]) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"工作地址未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    
    if (userModel.education == 0) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"学历未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    if (userModel.profession == 0) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"工作职业未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (userModel.income == 0) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"月收入未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (userModel.marital_status == 0) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"婚姻状况未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (userModel.child_status == 0) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"有无子女未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    if (userModel.years_to_marry == 0) {
        
        [SVProgressHUD showImage:AlertErrorImage status:@"几年内结婚未填写，\n谈恋爱我们是认真的"];
        [SVProgressHUD dismissWithDelay:2];
        return NO;
    }
    
    //    if (userModel.house_status == 0) {
    //
    //        [SVProgressHUD showImage:AlertErrorImage status:@"有无房产未填写，\n谈恋爱我们是认真的"];
    //        [SVProgressHUD dismissWithDelay:2];
    //        return NO;
    //    }
    //
    //    if (userModel.car_status == 0) {
    //
    //        [SVProgressHUD showImage:AlertErrorImage status:@"有无车辆未填写，\n谈恋爱我们是认真的"];
    //        [SVProgressHUD dismissWithDelay:2];
    //        return NO;
    //    }
    
    return YES;
}

@end
