//
//  NetworkTool.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/13.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonNetwork.h"

@interface NetworkTool : NSObject

+ (NSURLSessionDataTask *)getVerifyCodeWithPhone:(NSString *)phone succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)registerWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code sign:(NSString *)sign exp:(NSInteger )exp succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)forgetPsdWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code sign:(NSString *)sign exp:(NSInteger )exp succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)consummateWithName:(NSString *)name plates:(NSString *)plates  type:(NSInteger)type succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)getLimitNoWithCity:(NSString *)city succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;
@end
