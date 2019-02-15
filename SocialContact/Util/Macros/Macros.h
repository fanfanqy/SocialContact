//
//  Macros.h
//  GuaGua
//
//  Created by fqy on 2018/5/16.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

//在调试的时候，会输出（格式：文件名:行号）日志。在Release正式版本的时候，会关闭日志输出。
#ifndef __OPTIMIZE__
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:[%s]\t\t[%s:%d]\n\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String],__func__,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__);
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(FORMAT, ...) nil
#define debugMethod()
#endif

//------------------------------------------------------------------------------
// 全局编译点, Block引用控制
//------------------------------------------------------------------------------

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#define CurrentAPPName [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define INS_SCHEMA @"com.SocialContact.zn"
#define INS_APP_NAME @"社交"
#define INS_APP_VERSION         [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#define INS_DEVICE_SYS_VERSION  [UIDevice currentDevice].systemVersion
#define INS_DEVICE_UUID         [UIDevice currentDevice].identifierForVendor.UUIDString
#undef  INS_DOMAIN
#define INS_DOMAIN      @"cn.zn.SocialContact"


#define IOS11 @available(iOS 11.0, *)

//字符串是否为空
#define LGFStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空
#define LGFArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define LGFDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

/**
 注册cell----nib
 
 @param UITableView tableView
 @param NSString nib名称
 @return cell
 */
#undef RegisterNibCell
#define RegisterNibCell(UITableView, NSString)\
[UITableView registerNib:[UINib nibWithNibName:NSString bundle:Bundle] forCellReuseIdentifier:NSString];


/**
 注册cell -----class
 
 @param UITableView tableView
 @param NSString 类名
 @return
 */
#undef RegisterClassCell
#define RegisterClassCell(UITableView, NSString)\
[self.tableView registerClass:NSClassFromString(NSString) forCellReuseIdentifier:NSString];

#undef TableViewGetCell
#define TableViewGetCell(UITableView, NSString)\
[UITableView dequeueReusableCellWithIdentifier:NSString];

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;

/** APP版本号 */
#define APP_VERSION        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/** APP BUILD 版本号 */
#define APP_BUILD_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

/** 设备判断 */
#define IS_IPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_PAD    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** iPhone的型号 */
#define IS_IPHONE4        ([[UIScreen mainScreen] bounds].size.height == 480)
#define IS_IPHONE5        ([[UIScreen mainScreen] bounds].size.height == 568)
#define IS_IPHONE6        ([[UIScreen mainScreen] bounds].size.height == 667)
#define IS_IPHONE6_PLUS   ([[UIScreen mainScreen] bounds].size.height == 736)
#define IS_IPHONEX        ([[UIScreen mainScreen] bounds].size.height == 812 || [[UIScreen mainScreen] bounds].size.height == 896)

/*
 状态栏
 如果项目隐藏了状态栏，[UIApplication sharedApplication].statusBarFrame.size.height就是0,注意一下
 */
#define StatusBarHeight          [[UIApplication sharedApplication] statusBarFrame].size.height
/* 宏定义 获取当前的 状态栏的高度 和导航栏的高度
 */
#define GuaTopHeight            (StatusBarHeight + 44)
#define UITabBarHeight          (IS_IPHONEX? 83 :49) //底部高度
#define iPhoneXVirtualHomeHeight 34
#define kGuaCellHightColor UIColorHex(f0f0f0)

#define AlertSuccessImage [UIImage imageNamed:@"success"]
#define AlertErrorImage [UIImage imageNamed:@"failure"]


#define kRequestMessageKey @"detail"

#define INS_ERROR_STR_DEFULT            @"请求出了点问题哦, 请稍后重试"

#define INS_TYPE_ERROR                  9000 // 类型错误
#define INS_NET_CREATE_ERROR_CODE       9001 // 网络请求创建错误

#define INS_NET_WHITELIST_ERROR_CODE    9002 // 不存在白名单内的网络请求
#define INS_NET_WHITELIST_ERROR \
[NSError errorWithDomain:INS_DOMAIN code:INS_NET_WHITELIST_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: INS_ERROR_STR_DEFULT}]

#define INS_NET_SERVER_ERROR_CODE       9003 // 服务器访问等错误
#define INS_NET_SERVER_ERROR \
[NSError errorWithDomain:INS_DOMAIN code:INS_NET_SERVER_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: INS_ERROR_STR_DEFULT}]

#define INS_NET_STATUS_ERROR_CODE       9004 // 接口错误

#undef  INS_P_STRONG
/**
 普通Strong属性
 */
#define INS_P_STRONG(__t__,__n__) \
@property ( nonatomic, strong ) __t__ __n__;

#undef  INS_P_ASSIGN
/**
 普通Assign属性
 */
#define INS_P_ASSIGN(__t__,__n__) \
@property ( nonatomic, assign ) __t__ __n__;

#ifndef    weakify
#define weakify( x ) \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x;
#endif    // #ifndef    @weakify

#ifndef    normalize
#define normalize( x ) \
try{} @finally{} __typeof__(x) x = __weak_##x##__;
#endif    // #ifndef    @normalize

#endif /* Macros_h */
