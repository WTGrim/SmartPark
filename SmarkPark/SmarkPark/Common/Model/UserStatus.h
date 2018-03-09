//
//  UserStatus.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/9.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStatus : NSObject

@property (assign, nonatomic, readonly) BOOL isLogin;
@property (strong, nonatomic, readonly) NSString *authPlatform;
@property (strong, nonatomic, readonly) NSString *authToken;
@property (strong, nonatomic, readonly) NSString *deviceId;
@property (strong, nonatomic, readonly) NSString *timeSpan;
@property (strong, nonatomic, readonly) NSString *userName;
@property (strong, nonatomic, readonly) NSString *authMessage;
@property (assign, nonatomic, readonly) BOOL isWXBind;
@property (strong, nonatomic, readonly) NSString *token;

+ (instancetype)shareInstance;
- (void)destoryUserStatus;
- (void)initWithDict:(NSDictionary *)dict;

@end
