//
//  MapManager.h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class MapManager;

@protocol MapManagerLocationDelegate <NSObject>

@optional

- (void)mapManager:(MapManager *)manager didUpdateAndGetLastCLLocation:(CLLocation *)location;
- (void)mapManager:(MapManager *)manager didReverseCLLocation:(CLPlacemark *)placemark;
- (void)mapManager:(MapManager *)manager didFailed:(NSError *)error;
- (void)mapManagerServerClosed:(MapManager *)manager;

@end

@interface MapManager : NSObject

@property (nonatomic, weak)     id<MapManagerLocationDelegate> delegate;
@property (nonatomic, readonly) CLAuthorizationStatus          authorizationStatus;

- (void)start;

// 自定
INS_P_ASSIGN(CGFloat, latitude); // 纬度

INS_P_ASSIGN(CGFloat, longitude); // 精度

INS_P_STRONG(NSString *, myLocation);

@end
