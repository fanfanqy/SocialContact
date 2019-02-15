//
//  Help.h
//  SocialContact
//
//  Created by EDZ on 2019/1/24.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Help : NSObject

//在最大压缩条件下,文件小于 maxFileSize
+ (NSData *)compressImage:(UIImage *)image;

/*
 PROFESSION_CHOICE = (
 (0, '未知'),
 (1, '事业单位'),
 (2, '政府机关'),
 (3, '私营企业'),
 (4, '自由职业'),
 (5, '其他'),
 )
 
 # education
 EDUCATION_CHOICE = (
 (0, '未知'),
 (1, '初中'),
 (2, '高中'),
 (3, '中专'),
 (4, '大专'),
 (5, '本科'),
 (6, '硕士'),
 (7, '博士'),
 (8, '院士'),
 )
 
 # income
 INCOME_CHOICE = (
 (0, '未知'),
 (1, '10万以下'),
 (2, '10万~20万'),
 (3, '20万~50万'),
 (4, '50万以上'),
 )
 
 # marital_status
 MARITAL_STATUS_CHOICE = (
 (0, '未知'),
 (1, '未婚'),
 (2, '离异'),
 (3, '丧偶'),
 )
 
 # child_status
 CHILD_STATUS_CHOICE = (
 (0, '未知'),
 (1, '无'),
 (2, '有，和我在一起'),
 (3, '有，不和我在一起'),
 )

 
 
 */
// 职业
+ (NSString *)profession:(NSInteger)professionType;

// 教育
+ (NSString *)education:(NSInteger)educationType;

// 收入
+ (NSString *)income:(NSInteger)incomeType;

// 婚姻状态
+ (NSString *)marital_status:(NSInteger)marital_statusType;

// 小孩状态
+ (NSString *)child_status:(NSInteger)child_statusType;

// 几年内结婚
+ (NSString *)yearsToMarial:(NSInteger)yearsToMarialType;
@end

NS_ASSUME_NONNULL_END
