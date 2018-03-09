//
//  UserStatus.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/9.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "UserStatus.h"

@implementation UserStatus

+ (instancetype)shareInstance {
    static UserStatus *user = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        user = [[UserStatus alloc] init];
    });
    return user;
}

- (void)initWithDict:(NSDictionary *)dict{
    _isLogin = YES;
    if (dict[@"UserName"]) {
        _userName = dict[@"UserName"];
    }
    if (dict[@"TimeSpan"]) {
        _timeSpan = dict[@"TimeSpan"];
    }
    if (dict[@"AuthToken"]) {
        _authToken = dict[@"AuthToken"];
    }
    if (dict[@"AuthPlatform"]) {
        _authPlatform = dict[@"AuthPlatform"];
    }
    if (dict[@"DeviceId"]) {
        _deviceId = dict[@"DeviceId"];
    }
    
    if (dict[@"Message"]) {
        _authMessage = dict[@"Message"];
    }
    
    if ([dict objectForKey:@"IsBindWX"]) {
        _isWXBind = [[dict objectForKey:@"IsBindWX"] boolValue];
    }
}

- (void)addUserToken:(NSString *)token {
    _token = token;
}

- (void)destoryUserStatus {
    _isLogin = NO;
    _userName = nil;
    _timeSpan = nil;
    _authToken = nil;
    _authPlatform = nil;
    _deviceId = nil;
    _authMessage = nil;
    _isWXBind = NO;
}
@end
