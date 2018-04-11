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

/**
 验证码
 */
+ (NSURLSessionDataTask *)getVerifyCodeWithPhone:(NSString *)phone succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

/**
 注册
 */
+ (NSURLSessionDataTask *)registerWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code sign:(NSString *)sign exp:(NSInteger )exp succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

/**
 登录
 */
+ (NSURLSessionDataTask *)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)forgetPsdWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code sign:(NSString *)sign exp:(NSInteger )exp succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)consummateWithName:(NSString *)name plates:(NSString *)plates  type:(NSInteger)type succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)getLimitNoWithCity:(NSString *)city succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)findCarportWithKeyword:(NSString *)Keyword province:(NSString *)province city:(NSString *)city district:(NSString *)district latitude:(CGFloat )latitude longitude:(CGFloat)longitude index:(NSInteger )index size:(NSInteger)size type:(NSInteger)type succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)pubCarportWithName:(NSString *)name phone:(NSString *)phone plates:(NSString *)plates type:(NSInteger)type size:(NSInteger)size price:(CGFloat)price start:(NSString *)start end:(NSString *)end  province:(NSString *)province city:(NSString *)city district:(NSString *)district address:(NSString *)address latitude:(CGFloat )latitude longitude:(CGFloat)longitude succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)getLastParkWithSucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)getUserInfoWithSucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

+ (NSURLSessionDataTask *)getUserWalletWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

/**
 停车记录
 */
+ (NSURLSessionDataTask *)getUserUse_recordWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;
/**
 发布记录
 */
+ (NSURLSessionDataTask *)getUserPublish_recordWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

/**
 预定接口
 */
+ (NSURLSessionDataTask *)getParkingReservationWithId:(NSInteger)Id SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

/**
 预定车位信息
 */
+ (NSURLSessionDataTask *)getParkingInfoWithId:(NSInteger)Id SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;

/**
 当前用户是否有未完成的预定车位
 */
+ (NSURLSessionDataTask *)getParkingStatusWithSucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed;
@end
