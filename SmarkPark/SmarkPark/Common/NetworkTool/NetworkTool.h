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

+ (NSURLSessionDataTask *)findCarportWithKeyword:(NSString *)Keyword province:(NSString *)province city:(NSString *)city district:(NSString *)district latitude:(CGFloat )latitude longitude:(CGFloat)longitude index:(NSInteger )index size:(NSInteger)size type:(NSInteger)type succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)pubCarportWithName:(NSString *)name phone:(NSString *)phone plates:(NSString *)plates type:(NSInteger)type size:(NSInteger)size price:(CGFloat)price start:(NSString *)start end:(NSString *)end  province:(NSString *)province city:(NSString *)city district:(NSString *)district address:(NSString *)address latitude:(CGFloat )latitude longitude:(CGFloat)longitude succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)getLastParkWithSucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

@end
