//
//  Ins_Request.h
//  AVInsurance
//
//  Created by Dylan on 2016/7/29.
//  Copyright © 2016年 Dylan. All rights reserved.
//


#import "Ins_Enviroment.h"
#import "Ins_RequestProtocol.h"

@interface InsRequest : NSObject <InsEnviroment>

@property ( nonatomic, strong ) NSString *callBackFunctionId;
/**
 网络请求api地址
 */
@property (readonly,strong)NSString *apiPath;

/**
 网络请求参数字典
 */
@property (readonly,nonatomic) id parameters;

/**
 结果代理
 */
@property (nonatomic,weak) id<InsRequestProtocol> delegate;

/**
 文件数组 内容为相应格式的字典
 */
@property (readonly,strong) NSArray * files;

/**
 返回的JSON对象, 这个时候已经被处理成Dict, Array 或者 String
 */
@property (readonly,strong) id responseObject;

/**
 网络请求错误, 是否错误
 */
@property (readonly,strong) NSError * error;

/**
 当前的网络请求`DataTask`
 */
@property (readonly,strong) NSURLSessionTask * task;

//------------------------------------------------------------------------------
// 初始化方法
//------------------------------------------------------------------------------

/**
 为MVVM Request, 在方法局部, 方法结束对象释放, 应写作属性或者全局变量
 @param apiPath         API具体路径
 @param parameters      参数字典, 可以为空
 @param delegate        代理
 */
+ (instancetype) requestWithPath: (NSString *) apiPath
                      parameters: (id) parameters
                        delegate: (id<InsRequestProtocol>) delegate;

/**
 为MVVM Request, 在方法局部, 方法结束对象释放, 应写作属性或者全局变量
 @param apiPath         API具体路径
 @param parameters      参数字典, 可以为空
 @param files           文件数组, 内容为字典, 参照方法内部取值方式赋值
 @param delegate        代理
 */
+ (instancetype) requestWithPath: (NSString *) apiPath
                      parameters: (id) parameters
                           files: (NSArray *) files
                        delegate: (id<InsRequestProtocol>) delegate;


/*[POST] healthy/alarmInit
{
    data =     {
        count = 2;
        rows =         (
                        {
                            deviceId = 1;
                            functionId = 1;
                            functionName = "\U8840\U6c27";
                            icon = "http://p7rw8ozp8.bkt.clouddn.com/index-xueyang.png";
                            lowerValue = 95;
                            note = "\U5b89\U5168\U8303\U56f4\U7684\U503c[95~100]";
                            preLowerValue = 95;
                            preUpperValue = 100;
                            precision = 0;
                            unit = "%";
                            uppderEnable = 100;
                            upperValue = 100;
                        },
                        {
                            deviceId = 1;
                            functionId = 3;
                            functionName = "\U5fc3\U7387";
                            icon = "http://p7rw8ozp8.bkt.clouddn.com/index-xinlv.png";
                            lowerValue = 60;
                            note = "\U5b89\U5168\U8303\U56f4\U7684\U503c[60~100]";
                            preLowerValue = 50;
                            preUpperValue = 110;
                            precision = 0;
                            unit = BPM;
                            uppderEnable = 110;
                            upperValue = 100;
                        }
                        );
    };
    errorCode = 200;
    errorMessage = success;
}
 */

/**
 为MVVM Request, 在方法局部, 方法结束对象释放, 应写作属性或者全局变量
 @param apiPath         API具体路径
 @param parameters      参数字典, 可以为空
 @param handler         Block形式
 */
+ (instancetype) requestWithPath: (NSString *) apiPath
                      parameters: (id) parameters
               completionHandler: (void (^)(InsRequest *)) handler;

+ (instancetype) requestWithPath: (NSString *) apiPath
											parameters: (id) parameters
											 aesHeader: (NSDictionary *) datas
							 completionHandler: (void (^)(InsRequest *)) handler;

@end
