//
//  LocationTool.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/23.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "LocationTool.h"
#import "CommonSystemAlert.h"

@interface LocationTool()<AMapLocationManagerDelegate>

//定位
@property(nonatomic, strong)AMapLocationManager *locationManager;

@end

@implementation LocationTool

+ (instancetype)shareInstance{
    static LocationTool *location;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[LocationTool alloc]init];
        [location startLocation];
    });
    return location;
}

- (void)startLocation{
    
    if ([self checkLocationAuthorization]) {
        _locationManager = [[AMapLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager setLocatingWithReGeocode:YES];
        _locationManager.locationTimeout = 10;
        _locationManager.reGeocodeTimeout = 10;
        [_locationManager startUpdatingLocation];

    }
}

- (void)beginLocation{
    if (_locationManager) {
        [_locationManager startUpdatingLocation];
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"定位工具类定位失败：%@", error);
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    if (reGeocode != nil) {
        NSArray *address = nil;
        address = @[reGeocode.province?:@"", reGeocode.city?:@"", reGeocode.district?:@""];
        CLLocation *currentLocation = nil;
        currentLocation = location;
        if (_locationCompleted) {
            _locationCompleted(address, currentLocation);
            [_locationManager stopUpdatingLocation];
        }
    }
}



- (BOOL)checkLocationAuthorization {
    CLAuthorizationStatus type = [CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled] || type == kCLAuthorizationStatusDenied) {
        return NO;
    }else {
        return YES;
    }
}


@end
