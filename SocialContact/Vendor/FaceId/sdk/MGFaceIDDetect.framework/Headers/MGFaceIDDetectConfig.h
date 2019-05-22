//
//  MGFaceIDDetectConfig.h
//  MGFaceIDDetect
//
//  Created by LiangJuzi on 2018/12/11.
//  Copyright © 2018 Megvii. All rights reserved.
//

#ifndef MGFaceIDDetectConfig_h
#define MGFaceIDDetectConfig_h

/**
 *  自助接入平台活体检测失败错误类型
 */
typedef enum : NSUInteger {
    ZZPlatformErrorUnknown                      = 50000,                     //  未知错误
    ZZPlatformErrorReferToSamePerson            = 51000,                     //  待比对照片与数据源照片或参考照对比均是同一个人
    ZZPlatformErrorPassDetectButDifferentPeople = 52000,                     //  活体通过，但对比不是一个人
    ZZPlatformErrorNoIDCardNum                  = 53000,                     //  权威数据错误可能无此身份证号
    ZZPlatformErrorIDCardMessageNotMatch        = 53000,                     //  身份证号，姓名不匹配
    ZZPlatformErrorNoFaceFound                  = 53000,                     //  权威数据照片中找不到人脸
    ZZPlatformErrorNoIDFhoto                    = 53000,                     //  权威数据照片中找不到图片
    ZZPlatformErrorPhotoFormat                  = 53000,                     //  权威数据照片格式错误
    ZZPlatformErrorDataSource                   = 53000,                     //  权威数据错误
    ZZPlatformErrorMaskAttack                   = 54100,                     //  假脸攻击
    ZZPlatformErrorChangeFaceAttack             = 54100,                     //  换脸攻击
    ZZPlatformErrorBizToken                     = 54200,                     //  传入 biz_token 不符合要求
    ZZPlatformErrorBizConfig                    = 54200,                     //  传入 biz_config 不符合要求
    ZZPlatformErrorAuthenticationFail           = 54200,                     //  鉴权失败
    ZZPlatformErrorMobilePhoneNotSupport        = 54200,                     //  手机在不支持列表里
    ZZPlatformErrorSDKTooOld                    = 54200,                     //  SDK版本过旧，已经不被支持
    ZZPlatformErrorUserCancellation             = 54200,                     //  用户取消了验证
    ZZPlatformErrorUserTimeOut                  = 54200,                     //  用户验证流程超时
    ZZPlatformErrorVerificationFailure          = 54200,                     //  用户活体验证失败
    ZZPlatformErrorUndetectedFace               = 54200,                     //  长时间没有检测到人脸
    ZZPlatformErrorAction                       = 54200,                     //  不符合动作提示
    ZZPlatformErrorFetchLiveConfig              = 54200,                     //  获取活体信息失败
    ZZPlatformErrorSignInvalid                  = 55000,                     //  传入 sign 不符合要求
    ZZPlatformErrorSignVesionInvalid            = 55000,                     //  传入 signVersion 不符合要求
    ZZPlatformErrorSignExpired                  = 55000,                     //  传入 sign 过期
    ZZPlatformErrorSignReplayAttack             = 55000,                     //  重放攻击，单次有效的签名被多次使用
    ZZPlatformErrorApiKeyBeDiscontinued         = 55000,                     //  api_key被停用
    ZZPlatformErrorIPNotAllowed                 = 55000,                     //  不允许访问的IP
    ZZPlatformErrorNonEnterpriseCertification   = 55000,                     //  客户未进行企业认证
    ZZPlatformErrorBalanceNotEnough             = 55000,                     //  余额不足
    ZZPlatformErrorMoreRetryTimes               = 55000,                     //  超过重试次数
    ZZPlatformErrorAccountDiscontinued          = 55000,                     //  用户帐号已停用
    ZZPlatformErrorUserCancel                   = 56000,                     //  用户取消
    ZZPlatformErrorNoCameraPermission           = 56000,                     //  没有打开相机的权限，请开启权限后重试
    ZZPlatformErrorIllegalParameter             = 56000,                     //  传入参数不合法,error_start_detect_VC_nil
    ZZPlatformErrorBundleId                     = 56000,                     //  此 APP 的bundle_id 在系统的黑名单库里
    ZZPlatformErrorNoNetPermission              = 56000,                     //  网络出错或者连不上互联网，请连接上互联网后重试
    ZZPlatformErrorFaceInitAuthentication       = 56000,                     //  无法启动人脸识别,SDK 鉴权失败
    ZZPlatformErrorLivenessDetectFailed         = 56000,                     //  活体检测不通过
    ZZPlatformErrorNoSensorPermission           = 56000,                     //  没有运动传感器权限（理论上不会出现）
    ZZPlatformErrorInitFailed                   = 56000,                     //  SDK 初始化失败
} ZZPlatformErrorType;

//  活体检测语言类型，默认值为`MGFaceIDDetectionZh`
typedef enum : NSUInteger {
    MGFaceIDDetectionZh = 0,                    //  中文
    MGFaceIDDetectionEn                         //  英文
} FaceIDDetectBundleLanguageKey;


//  活体检测手机垂直检测类型，默认值为`MGFaceIDLiveDetectPhoneVerticalFront`
typedef enum : NSUInteger {
    MGFaceIDLiveDetectPhoneVerticalFront            = 0,            //  仅在开始的2s内启用，2s后关闭该功能
    MGFaceIDLiveDetectPhoneVerticalContinue         = 1,            //  持续启用
    MGFaceIDLiveDetectPhoneVerticalDisable          = 2,            //  禁用
} MGFaceIDLiveDetectPhoneVerticalType;

typedef void(^FaceIDDetectBlock)(NSUInteger Code, NSString* Message);

#endif /* MGFaceIDDetectConfig_h */
