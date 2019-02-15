//
//  Ins_Singleton.h
//  AVInsurance
//
//  Created by Dylan on 2016/7/27.
//  Copyright © 2016年 Dylan. All rights reserved.
//


#undef	INS_SINGLETON
#define INS_SINGLETON( ... ) \
        - (instancetype)sharedInstance; \
        + (instancetype)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( ... ) \
        - (instancetype)sharedInstance \
        { \
            return [[self class] sharedInstance]; \
        } \
        + (instancetype)sharedInstance \
        { \
            static dispatch_once_t once; \
            static id __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
            return __singleton__; \
        }

#undef	DEF_SINGLETON_AUTOLOAD
#define DEF_SINGLETON_AUTOLOAD( __class ) \
        DEF_SINGLETON( __class ) \
        + (void)load \
        { \
            [self sharedInstance]; \
        }

@interface InsSingleton : NSObject

@end
