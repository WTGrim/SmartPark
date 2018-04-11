//
//  NetworkTool.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/13.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "NetworkTool.h"
#import "JSONKit.h"

@implementation NetworkTool

+ (NSURLSessionDataTask *)getVerifyCodeWithPhone:(NSString *)phone succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:phone forKey:kPhone];
    NSString *url = [NSString stringWithFormat:@"%@/sms/get",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)registerWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code sign:(NSString *)sign exp:(NSInteger)exp succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:phone forKey:kPhone];
    [param setObject:pwd forKey:@"pwd"];
    [param setObject:code forKey:@"code"];
    [param setObject:sign forKey:@"sign"];
    [param setObject:@(exp) forKey:@"exp"];

    NSString *url = [NSString stringWithFormat:@"%@/user/register",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:phone forKey:kPhone];
    [param setObject:pwd forKey:@"pwd"];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/login",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)forgetPsdWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code sign:(NSString *)sign exp:(NSInteger )exp succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:phone forKey:kPhone];
    [param setObject:pwd forKey:@"pwd"];
    [param setObject:code forKey:@"code"];
    [param setObject:sign forKey:@"sign"];
    [param setObject:@(exp) forKey:@"exp"];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/forget",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)consummateWithName:(NSString *)name plates:(NSString *)plates  type:(NSInteger)type succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:name forKey:kName];
    [param setObject:plates forKey:kPlates];
    [param setObject:@(type) forKey:kType];
    NSString *url = [NSString stringWithFormat:@"%@/user/a/consummate",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)getLimitNoWithCity:(NSString *)city succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{

    NSString *url = [NSString stringWithFormat:@"http://v.juhe.cn/xianxing/index?key=%@&city=%@&type=1",JUHE_KEY, @"chengdu"];
    return [CommonNetwork postDataWithUrl:url param:nil showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)findCarportWithKeyword:(NSString *)keyword province:(NSString *)province city:(NSString *)city district:(NSString *)district latitude:(CGFloat )latitude longitude:(CGFloat )longitude index:(NSInteger )index size:(NSInteger)size type:(NSInteger)type succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:keyword forKey:@"Keyword"];
    [param setObject:province forKey:@"Province"];
    [param setObject:city forKey:@"City"];
    [param setObject:district forKey:@"District"];
    [param setObject:@(latitude) forKey:@"Latitude"];
    [param setObject:@(longitude) forKey:@"Longitude"];
    [param setObject:@(index) forKey:@"Index"];
    [param setObject:@(size) forKey:@"Size"];
    [param setObject:@(type) forKey:@"Type"];
    NSString *url = [NSString stringWithFormat:@"%@/parking/list",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)pubCarportWithName:(NSString *)name phone:(NSString *)phone plates:(NSString *)plates type:(NSInteger)type size:(NSInteger)size price:(CGFloat)price start:(NSString *)start end:(NSString *)end  province:(NSString *)province city:(NSString *)city district:(NSString *)district address:(NSString *)address latitude:(CGFloat )latitude longitude:(CGFloat)longitude succeedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:name forKey:@"name"];
    [param setObject:phone forKey:@"phone"];
    [param setObject:plates forKey:@"plates"];
    [param setObject:@(type) forKey:@"type"];
    [param setObject:@(size) forKey:@"size"];
    [param setObject:@(price) forKey:@"price"];
    [param setObject:start forKey:@"start"];
    [param setObject:end forKey:@"end"];
    [param setObject:province forKey:@"province"];
    [param setObject:city forKey:@"city"];
    [param setObject:district forKey:@"district"];
    [param setObject:address forKey:@"address"];
    [param setObject:@(latitude) forKey:@"latitude"];
    [param setObject:@(longitude) forKey:@"longitude"];

    NSString *url = [NSString stringWithFormat:@"%@/parking/add",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)getLastParkWithSucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{

    NSString *url = [NSString stringWithFormat:@"%@/parking/last",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:nil showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)getUserInfoWithSucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/a/info",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:nil showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)getUserWalletWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@(pageIndex) forKey:kIndex];
    [param setObject:@(pageSize) forKey:kSize];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/a/wallet",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)getUserUse_recordWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@(pageIndex) forKey:kIndex];
    [param setObject:@(pageSize) forKey:kSize];
    NSString *url = [NSString stringWithFormat:@"%@/user/a/use_record",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)getUserPublish_recordWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@(pageIndex) forKey:kIndex];
    [param setObject:@(pageSize) forKey:kSize];
    NSString *url = [NSString stringWithFormat:@"%@/user/a/publish_record",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)getParkingReservationWithId:(NSInteger)Id SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@(Id) forKey:kId];
    NSString *url = [NSString stringWithFormat:@"%@/parking/reservation",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)getParkingInfoWithId:(NSInteger)Id SucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@(Id) forKey:kId];
    NSString *url = [NSString stringWithFormat:@"%@/parking/info",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:param showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

+ (NSURLSessionDataTask *)getParkingStatusWithSucceedBlock:(RequestSucceed)succeed failedBlock:(RequestFailed)failed{
    NSString *url = [NSString stringWithFormat:@"%@/parking/status",SERVER_IP];
    return [CommonNetwork postDataWithUrl:url param:nil showLoader:NO showAlert:true gZip:NO succeedBlock:succeed failedBlock:failed];
}

@end
