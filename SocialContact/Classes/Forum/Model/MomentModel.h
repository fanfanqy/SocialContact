//
//  MomentModel.h
//  SocialContact
//
//  Created by EDZ on 2019/1/12.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentImageModel.h"
#import "CommentModel.h"
#import "TopicModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MomentModel : NSObject

INS_P_ASSIGN(NSInteger, iD); // "id": 16,
INS_P_STRONG(NSString *, text); // "text": "this is a title 2222333ww",
INS_P_STRONG(NSArray<MomentImageModel *> *,images);// list相册 或 用户主页相册
INS_P_STRONG(NSString *,latitude);
INS_P_STRONG(NSString *, longitude);
INS_P_STRONG(NSString *,create_at);
INS_P_STRONG(NSString *,update_at);
INS_P_STRONG(SCUserInfo *,customer);

INS_P_ASSIGN(NSInteger,comment_total);
INS_P_ASSIGN(NSInteger,like_total);
INS_P_ASSIGN(BOOL,is_hidden_name);
INS_P_STRONG(NSString *,address);
INS_P_ASSIGN(NSInteger,function_type);

INS_P_ASSIGN(NSInteger,count);
INS_P_STRONG(NSString *,next);
INS_P_STRONG(NSString *,previous);
INS_P_ASSIGN(NSInteger,page_count);

//INS_P_STRONG(NSArray<CommentModel *> *,results);
INS_P_STRONG(NSArray<SCUserInfo *> *,from_customer);
INS_P_STRONG(NSArray<SCUserInfo *> *,to_customer);

INS_P_STRONG(NSArray<TopicModel *> *,topic);

INS_P_ASSIGN(NSInteger,action_type);

INS_P_ASSIGN(NSInteger,status);



// 用户 技能接口数据解析
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
// 上面有了
//INS_P_ASSIGN(NSArray *,images);   //  list        相册

@end

NS_ASSUME_NONNULL_END
