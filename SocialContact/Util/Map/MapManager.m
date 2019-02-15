//
//  MapManager.m

#import "MapManager.h"

@interface MapManager ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapManager

- (void)start {
    
    _locationManager          = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
		//每隔多少米定位一次（这里的设置为500米）
	_locationManager.distanceFilter = 500;
		//设置定位的精准度，一般精准度越高，越耗电
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
//    [manager stopUpdatingLocation];
	
    if (_delegate && [_delegate respondsToSelector:@selector(mapManager:didUpdateAndGetLastCLLocation:)]) {
        
        CLLocation *location = [locations lastObject];
        [_delegate mapManager:self didUpdateAndGetLastCLLocation:location];
		
		CLGeocoder *geocoder = [[CLGeocoder alloc]init];
		@weakify(self);
		[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
			if (error) {
				NSLog(@"位置反编码失败error%@",error);
			}else{
				CLPlacemark *placemark=[placemarks firstObject];
				if ([_delegate respondsToSelector:@selector(mapManager:didReverseCLLocation:)]) {
					[_delegate mapManager:self didReverseCLLocation:placemark];
				}
			}
		}];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"定位失败");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        
        NSLog(@"定位功能关闭");
        if (_delegate && [_delegate respondsToSelector:@selector(mapManagerServerClosed:)]) {
            
            [_delegate mapManagerServerClosed:self];
        }
        
    } else {
        
        NSLog(@"定位功能开启");
        if (_delegate && [_delegate respondsToSelector:@selector(mapManager:didFailed:)]) {
            
            NSLog(@"%@", error);
            [_delegate mapManager:self didFailed:error];
        }
    }
}

@synthesize authorizationStatus = _authorizationStatus;

- (CLAuthorizationStatus)authorizationStatus {
    
    return [CLLocationManager authorizationStatus];
}

@end
