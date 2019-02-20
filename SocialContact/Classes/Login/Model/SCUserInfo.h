//
//  SCUserInfo.h
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
# profession
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
typedef NS_ENUM(NSInteger,PROFESSION_CHOICE){
    PROFESSION_CHOICE_Unknow = 0,
    PROFESSION_CHOICE_Institutions = 1,     //(1, '事业单位'),
    PROFESSION_CHOICE_Office = 2,
    PROFESSION_CHOICE_PrivateBusiness = 3,  //(3, '私营企业'),
    PROFESSION_CHOICE_Freelance = 4,        //(4, '自由职业'),
    PROFESSION_CHOICE_Other = 5,            //(5, '其他'),
};

typedef NS_ENUM(NSInteger,EDUCATION_CHOICE){
    /*
    (0, '未知'),
    (1, '初中'),
    (2, '高中'),
    (3, '中专'),
    (4, '大专'),
    (5, '本科'),
    (6, '硕士'),
    (7, '博士'),
    (8, '院士'),
    */
    EDUCATION_CHOICE_Unknow = 0,
    EDUCATION_CHOICE_ChuZhong = 1,
    EDUCATION_CHOICE_GaoZhong = 2,
    EDUCATION_CHOICE_ZhongZhuan = 3,
    EDUCATION_CHOICE_DaZhuan = 4,
    EDUCATION_CHOICE_BenKe = 5,
    EDUCATION_CHOICE_ShuoShi = 6,
    EDUCATION_CHOICE_BoShi = 7,
    EDUCATION_CHOICE_YuanShi = 8,
    
};

typedef NS_ENUM(NSInteger,INCOME_CHOICE){
    /*
     (0, '未知'),
     (1, '10万以下'),
     (2, '10万~20万'),
     (3, '20万~50万'),
     (4, '50万以上'),
     */
    INCOME_CHOICE_Unknow = 0,
    INCOME_CHOICE_010 = 1,
    INCOME_CHOICE_1020 = 2,
    INCOME_CHOICE_2050 = 3,
    INCOME_CHOICE_50 = 4,
    
};

typedef NS_ENUM(NSInteger,MARITAL_STATUS_CHOICE){
    MARITAL_STATUS_CHOICE_Unknow = 0,
    MARITAL_STATUS_CHOICE_WeiHun = 1,
    MARITAL_STATUS_CHOICE_LiYi = 2,
    MARITAL_STATUS_CHOICE_SangOu = 3,
};

typedef NS_ENUM(NSInteger,CHILD_STATUS_CHOICE){
    CHILD_STATUS_CHOICE_Unknow = 0,
    CHILD_STATUS_CHOICE_Wu = 1,
    CHILD_STATUS_CHOICE_YouWithMe = 2,
    CHILD_STATUS_CHOICE_YouUnWithMe = 3,
};


@interface SCUserInfo : NSObject

/*
 
 id    int        coustomer id
 user    int        customer的 user_id
 name    int        名字
 age    int        年龄， null表示未设置
 gender    int    0 ， 1， 2    性别： 0：未设置， 1：男， 2：女
 avatar_url    string        头像地址
 account    string        账号/手机号
 wechat_id    string        微信号
 intro    string        个人简介
 address_home    string        家庭地址
 address_company    string        公司地址
 im_token    string        融云token
 following_count    int        关注多少人
 followers_count    int        粉丝数
 blocked_count    int        屏蔽多少人
 is_manager    bool        是否为管理员
 is_shop_keeper    bool        是否是商家
 skills    string        技能
 is_show_skill    bool        是否展示技能
 is_rut    bool        是否是相亲状态
 expect_desc    str        异性要求
 birthday    str        生日
 height    float        身高
 profession    int        职业
 education    int        学历
 income    int        收入
 marital_status    int        婚姻状况
 child_status    int        有无小孩
 years_to_marry    int        几年内结婚
 score    int        自评分数 0~10
 condition    dict        择偶标准
 images    list        相册
 service_vip_expired_at    string        会员过期时间
 service_show_index_expired_at    string        置顶过期时间
 invitecode    string        邀请码
 

 
 */

INS_P_ASSIGN(NSInteger, iD);
INS_P_ASSIGN(NSInteger, userId);
INS_P_STRONG(NSString *, name);
INS_P_ASSIGN(NSInteger, age);
INS_P_ASSIGN(NSInteger, gender);
INS_P_STRONG(NSString *, avatar_url);
INS_P_STRONG(NSString *, account);
INS_P_STRONG(NSString *, wechat_id);
INS_P_STRONG(NSString *, intro);
INS_P_STRONG(NSString *, address_home);
INS_P_STRONG(NSString *, address_company);
INS_P_STRONG(NSString *,im_token);
INS_P_ASSIGN(NSInteger,following_count);
INS_P_ASSIGN(NSInteger,followers_count);
INS_P_ASSIGN(NSInteger,blocked_count);
//关注状态， -1：未关注， 0：屏蔽， 1：正在关注， 2：互相关注
INS_P_ASSIGN(NSInteger,relation_status);
INS_P_ASSIGN(BOOL,is_myself);
INS_P_ASSIGN(BOOL,is_manager);
INS_P_ASSIGN(BOOL,is_shop_keeper);
INS_P_ASSIGN(BOOL,is_show_skill);
INS_P_STRONG(NSString *,skills);
INS_P_ASSIGN(BOOL,is_rut);
INS_P_STRONG(NSString *,last_request_at);
INS_P_STRONG(NSString *,expect_desc);
INS_P_STRONG(NSString *,birthday); //   str        生日
INS_P_ASSIGN(CGFloat ,height); //   float        身高
INS_P_ASSIGN(NSInteger, profession );//   int        职业
INS_P_ASSIGN(NSInteger,education ); //  int        学历
INS_P_ASSIGN(NSInteger,income );  // int        收入
INS_P_ASSIGN(NSInteger,marital_status);  //  int        婚姻状况
INS_P_ASSIGN(NSInteger,child_status); //   int        有无小孩
INS_P_ASSIGN(NSInteger,years_to_marry);  //  int        几年内结婚
INS_P_ASSIGN(NSInteger,score);   // int        自评分数 0~10
INS_P_STRONG(NSDictionary *,condition);   // dict        择偶标准
INS_P_ASSIGN(NSArray *,images);   //  list        相册
INS_P_STRONG(NSString *,service_vip_expired_at);
INS_P_STRONG(NSString *,service_show_index_expired_at);
INS_P_STRONG(NSString *,invitecode);


// 自定
INS_P_ASSIGN(CGFloat, latitude); // 纬度

INS_P_ASSIGN(CGFloat, longitude); // 精度

//INS_P_STRONG(CLPlacemark *, placemark);

INS_P_STRONG(NSString *, myLocation);

@end

NS_ASSUME_NONNULL_END
