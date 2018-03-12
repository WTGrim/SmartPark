//
//  CommonNetwork.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/12.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ RequestSucceed)(NSDictionary *_Nullable result);
typedef void (^ RequestFailed)(id _Nullable errorInfo);

@interface CommonNetwork : NSObject

+ (NSURLSessionDataTask *_Nullable)postDataWithUrl:(NSString *_Nullable)url
                                             param:(id _Nullable)params
                                        showLoader:(BOOL)showLoader
                                         showAlert:(BOOL)showAlert
                                              gZip:(BOOL)gZip
                                      succeedBlock:(RequestSucceed _Nullable)succeedBlock
                                       failedBlock:(RequestFailed _Nullable)failed;

+ (NSURLSessionDataTask *_Nullable)postPayDataWithUrl:(NSString *_Nullable)url
                                                param:(id _Nullable)params
                                           showLoader:(BOOL)showLoader
                                            showAlert:(BOOL)showAlert
                                                 gZip:(BOOL)gZip
                                         succeedBlock:(RequestSucceed _Nullable)succeedBlock
                                          failedBlock:(RequestFailed _Nullable)failed;

+ (NSURLSessionDataTask *_Nullable)getDataWithUrl:(NSString *_Nullable)url
                                            param:(NSDictionary *_Nullable)params
                                       showLoader:(BOOL)showLoader
                                        showAlert:(BOOL)showAlert
                                             gZip:(BOOL)gZip
                                     succeedBlock:(RequestSucceed _Nullable)succeedBlock
                                      failedBlock:(RequestFailed _Nullable)failed;
@end

@interface NSDictionary (NetworkModel)

- (nullable NSString *)message;

- (BOOL)status;

- (nullable NSDictionary *)data;

@end
