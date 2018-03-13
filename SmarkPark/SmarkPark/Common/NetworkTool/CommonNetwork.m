//
//  CommonNetwork.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/12.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "CommonNetwork.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>
#import "UserStatus.h"
#import <CommonCrypto/CommonCrypto.h>
#import <zlib.h>

#define kTimeOutInterval 10

#define AuthFlag  @"05eckguqasvB4bVS14unBsq9gZvYBhgYN75T9MHMWAFzHZIwxEk0Kxwl+7nTwDwGyXPnbAjd6dQMTvqetXBkdPi9Flj2RXUlyELUribwlxmksE7t4iFWT/WdHgjZIwNYs0O/Q20sBfLWGvet1E/tihCS30QJ+UTzlnp8Tri/nilQoFebza3yXM/ZpzxYSXdyTSnJfYYpubDUQFtCArmjyGn0hbc9UTMxe3hyiCV/8pC719OjeJp9+8Dp69mw5hX825vMoeBqEq9FdYdoxsfsGBRifTxSw7ymayJ7FQ2Myaw="

static NSString *const kKeyValueType = @"application/x-www-form-urlencoded";


@implementation CommonNetwork

+ (NSURLSessionDataTask *)postDataWithUrl:(NSString *)url param:(id )params showLoader:(BOOL)showLoader showAlert:(BOOL)showAlert gZip:(BOOL)gZip succeedBlock:(RequestSucceed)succeedBlock failedBlock:(RequestFailed)failed {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:kKeyValueType forHTTPHeaderField:@"Content-Type"];

//    if ([UserStatus shareInstance].isLogin) {
//        [manager.requestSerializer setValue:[UserStatus shareInstance].authMessage forHTTPHeaderField:@"Agent-AppAuth"];
//    }else {
//        [manager.requestSerializer setValue:AuthFlag forHTTPHeaderField:@"Agent-AppAuth"];
//    }
    NSURLSessionDataTask *dataTask = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dealResult:responseObject showLoader:showLoader showAlert:showAlert succeedBlock:succeedBlock failedBlock:failed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.description containsString:@"Error Domain=NSURLErrorDomain Code=-1009 \"似乎已断开与互联网的连接。\""]) {
            failed(@{kMessage:@"似乎已断开与互联网的连接。"});
        }else {
            failed(@{kMessage:error.description});
        }
    }];
    return dataTask;
}

+ (NSURLSessionDataTask *)postPayDataWithUrl:(NSString *)url param:(id)params showLoader:(BOOL)showLoader showAlert:(BOOL)showAlert gZip:(BOOL)gZip succeedBlock:(RequestSucceed)succeedBlock failedBlock:(RequestFailed)failed {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([UserStatus shareInstance].isLogin) {
        [manager.requestSerializer setValue:[UserStatus shareInstance].authMessage forHTTPHeaderField:@"Agent-AppAuth"];
    }else {
        [manager.requestSerializer setValue:AuthFlag forHTTPHeaderField:@"Agent-AppAuth"];
    }
    NSURLSessionDataTask *dataTask =  [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dealResult:responseObject showLoader:showLoader showAlert:showAlert succeedBlock:succeedBlock failedBlock:failed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        if (failed) {
            failed(@{kMessage:error.description});
        }
    }];
    return dataTask;
}

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url param:(NSDictionary *)params showLoader:(BOOL)showLoader showAlert:(BOOL)showAlert gZip:(BOOL)gZip succeedBlock:(RequestSucceed)succeedBlock failedBlock:(RequestFailed)failed {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    if ([UserStatus shareInstance].isLogin) {
//        [manager.requestSerializer setValue:[UserStatus shareInstance].authMessage forHTTPHeaderField:@"Agent-AppAuth"];
//    }else {
//        [manager.requestSerializer setValue:AuthFlag forHTTPHeaderField:@"Agent-AppAuth"];
//    }
//    
    NSURLSessionDataTask *dataTask =  [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dealGetResult:responseObject showLoader:showLoader showAlert:showAlert succeedBlock:succeedBlock failedBlock:failed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        failed(@{kMessage:error.description});
    }];
    return dataTask;
}

+ (void)dealGetResult:(id)result showLoader:(BOOL)showLoader showAlert:(BOOL)showAlert succeedBlock:(RequestSucceed)succeedBlock failedBlock:(RequestFailed)failed{
    __autoreleasing NSError *error;
    id resultObj = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&error];
    if (error) {
        return;
    }
    succeedBlock(resultObj);
}

+ (void)dealResult:(id)result showLoader:(BOOL)showLoader showAlert:(BOOL)showAlert succeedBlock:(RequestSucceed)succeedBlock failedBlock:(RequestFailed)failed {
    __autoreleasing NSError *error;
    id resultObj = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&error];
    if (error) {
        return;
    }
    
    if ([resultObj status]) {
        succeedBlock(resultObj);
    }else {
        NSString *message = [resultObj message];
        if (!StringIsNull(message) &&[message containsString:@"验证失效，请重新登陆"]) {
            [[UserStatus shareInstance] destoryUserStatus];
        }
        if (failed) {
            failed(resultObj);
        }
    }
}

@end

@implementation NSDictionary (NetworkModel)

- (NSString *)message {
    return [self objectForKey:@"msg"];
}

- (BOOL)status {
    if ([[self objectForKey:@"code"] integerValue] ==  -1) {
        return true;
    }
    return false;
}

- (NSDictionary *)data {
    return [self objectForKey:@"data"];
}


@end
