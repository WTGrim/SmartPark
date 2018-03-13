//
//  UserStatus.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/9.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStatus : NSObject

/** 用户手机号 **/
@property (copy, nonatomic) NSString *phone;
/** 用户登录token **/
@property (copy, nonatomic) NSString *token;
/** 是否登录 **/
@property (assign, nonatomic) BOOL isLogin;

// 初始化
+ (instancetype)shareInstance;
// 生成用户数据
- (void)initWithDict:(NSDictionary *)dict;

//获取用户信息的字典
- (NSDictionary *)userInfoDict;

// 销毁用户信息
- (void)destoryUserStatus;

@end
