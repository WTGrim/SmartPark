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
    static UserStatus *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[UserStatus alloc] init];
    });
    return user;
}

- (void)initWithDict:(NSDictionary *)dict {
    _isLogin = YES;
    if (dict[kPhone]) {
        _phone = dict[kPhone];
    }
    if (dict[kToken]) {
        _token = dict[kToken];
    }
}


- (NSDictionary *)userInfoDict {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (!StringIsNull(_phone)) {
        [dict setObject:_phone forKey:kPhone];
    }
    if (!StringIsNull(_token)) {
        [dict setObject:_token forKey:kToken];
    }

    return dict;
}

- (void)destoryUserStatus {
    _isLogin = NO;
    _phone = nil;
    _token = nil;
}
@end
