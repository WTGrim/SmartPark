//
//  CommonTools.m
//  FineexFQXD
//
//  Created by ZhaoYu on 10/8/16.
//  Copyright © 2016 FineEx. All rights reserved.
//

#import "CommonTools.h"
#import "sys/utsname.h"


@implementation CommonTools

+ (BOOL)isTextFieldHasInputed:(UITextField *)textField {
    if (textField && textField.text.length > 0) {
        return YES;
    }
    return NO;
}

+ (void)setImageWithURL:(NSString *)urlStr imageVIew:(UIImageView *)imageView{
    __block UIImage *image = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                image = [UIImage imageWithData:data];
                imageView.image = image;
            }
        });
    });
}

+ (NSArray *)caculateDateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [formatter dateFromString:endTime];
    NSDate *begingDate = [formatter dateFromString:startTime];
    NSTimeInterval time;
    if (startTime != nil) {
        time = [endDate timeIntervalSinceDate:begingDate];
    } else {
        time = [endDate timeIntervalSinceDate:[NSDate date]];
    }
    int day = ((int)time) / (24 * 3600);
    int houre = ((int)time) % (24 * 3600) / 3600;
    int minute = ((int)(time - day * 24 * 3600 - houre * 3600)) / 60;
    int second = ((int)(time - minute * 60 - houre * 3600 - day * 24 * 3600));
    return @[@(day),@(houre),@(minute),@(second)];
}

+ (NSArray *)caculateHourDateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [formatter dateFromString:endTime];
    NSDate *begingDate = [formatter dateFromString:startTime];
    NSTimeInterval time;
    if (startTime != nil) {
        time = [endDate timeIntervalSinceDate:begingDate];
    } else {
        time = [endDate timeIntervalSinceDate:[NSDate date]];
    }
    int houre = ((int)time) / 3600;
    int minute = ((int)(time - houre * 3600)) / 60;
    int second = ((int)(time - minute * 60 - houre * 3600));
    return @[@(houre),@(minute),@(second)];
}

+ (NSString *)caculateTimeDistanceWithTime:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beginDate = [formatter dateFromString:time];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval times = [currentDate timeIntervalSinceDate:beginDate];
    if (times < 0) {
        return @"0分钟前";
    }
    if ((times / 60) < 60) {
        return [NSString stringWithFormat:@"%.0f分钟前",floor(times / 60)];
    }
    if ((times / 3600) < 24) {
        return [NSString stringWithFormat:@"%.0f小时前",floor(times / 3600)];
    }
    if ((times / (3600 * 24)) < 2) {
        return [NSString stringWithFormat:@"1天前"];
    }
    return time;
}

+ (NSDate *)dsperson_cacluteStringToDate:(NSString *)stringDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:stringDate];
}

+ (BOOL)dsperson_timeInterval:(NSDate *)first second:(NSDate *)second {
    //[first compare:second]; or
    return [first timeIntervalSinceDate:second] < 0.0 ? YES : NO;
}
#pragma mark —— 计算文本的高度
+ (CGRect)getTextRectWithString:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight{
    if (StringIsNull(string)) {
        return CGRectZero;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return rect;
}

+(void)saveLocalWithKey:(NSString*)key Obj:(id)obj
{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    [ud setObject:obj forKey:key];//设置值
    [[NSUserDefaults standardUserDefaults] synchronize]; //手动保存
}

+(id)loadLocalWithKey:(NSString*)key
{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    
    return [ud objectForKey:key];
}

+(void)removeLocalWithKey:(NSString*)key
{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];//设置值
    [[NSUserDefaults standardUserDefaults] synchronize]; //手动保存
}

+ (NSAttributedString *)getPriceAttributedStringWithString:(NSString *)priceStr{
    //    NSString *salesPriceStr = [NSString stringWithFormat:@"售价：¥%.2f",[[dic objectForKey:kSalePrice] floatValue]];
    NSRange startRange = [priceStr rangeOfString:@"¥"];
    NSRange endRange = [priceStr rangeOfString:@"."];
    NSMutableAttributedString *attributeSalePrice = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributeSalePrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(startRange.location + 1, endRange.location - startRange.location - startRange.length)];
    return attributeSalePrice;
}
+ (NSAttributedString *)dsperson_addPriceLabelThroughtLine:(NSString *)title {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title];
     [string addAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName : @(NSUnderlineStyleNone)} range:NSMakeRange(0, title.length)];
    return string;
}

+ (NSAttributedString *)getCommonPriceAttributedStringWithString:(NSString *)priceStr bigFont:(CGFloat)bigFont smallFont:(CGFloat)smallFont{
    NSMutableAttributedString *attributeSalePrice = [[NSMutableAttributedString alloc] initWithString:priceStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:bigFont]}];
    [attributeSalePrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:smallFont] range:NSMakeRange(0, 1)];
    return attributeSalePrice;
}

+ (NSAttributedString *)getMineGroupPriceAttributedStringWithString:(NSString *)priceStr{
    
    NSRange startRange = [priceStr rangeOfString:@"¥"];
    NSRange endRange = [priceStr rangeOfString:@"."];
    if (startRange.location > 100 || endRange.location > 100) {
        return nil;
    }
    NSMutableAttributedString *attributeSalePrice = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributeSalePrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(startRange.location, startRange.length)];
    [attributeSalePrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(1, endRange.location)];
    [attributeSalePrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(priceStr.length - 2, 2)];
    return attributeSalePrice;
}
+ (CGSize)convertSizeToScreenWithSize:(CGSize)size {
    CGFloat screenRate = SCREEN_WIDTH / size.width;
    CGFloat trueWith = SCREEN_WIDTH;
    CGFloat trueHeight = size.height * screenRate;
    return CGSizeMake(trueWith, trueHeight);
}

BOOL StringIsNull(NSString *string) {
    if (string == nil) {
        return YES;
    } else if ([string isEqual:[NSNull null]]) {
        return YES;
    }else if (string.length == 0) {
        return YES;
    }else if ([string isEqualToString:@"(null)"]) {
        return YES;
    } else if ([string isEqualToString:@"<null>"]) {
        return YES;
    } else if ([[string class] isEqual:[NSNull class]]) {
        return YES;
    }
    return NO;
}

BOOL chargeIdIsNullOrEmpty(id obj) {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *newObj = (NSDictionary *)obj;
        obj = (NSDictionary *)obj;
        if (!newObj || [newObj isEqual:[NSNull null]] || newObj.allKeys.count == 0) {
            if ([obj isKindOfClass:[NSMutableDictionary class]]) {
                obj = newObj.mutableCopy;
                return true;
            }
            obj = newObj.copy;
            return true;
        }
        return false;
    } else if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *newObj = (NSArray *)obj;
        obj = (NSArray *)obj;
        if (!newObj || [newObj isEqual:[NSNull null]] || newObj.count == 0) {
            if ([obj isKindOfClass:[NSMutableArray class]]) {
                obj = newObj.mutableCopy;
                return true;
            }
            obj = newObj.copy;
            return true;
        }
        return false;
    } else if ([obj isKindOfClass:[NSString class]]) {
        if (StringIsNull(obj)) {
            obj = @"";
            return true;
        }
        return false;
    }
    return true;
}
+ (NSString *)nullToString:(NSString *)string {
    if (StringIsNull(string)) {
        return @"";
    }
    return string;
}
NSString* DeleteWitheAndSpace(NSString *string) {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

+(NSArray *)priceToIntAndFolat:(NSString *)price {
    NSString *inteValue = [NSString stringWithFormat:@"%ld",(long)[price integerValue]];
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", price];
    if (price.length >= 3) {
        [str deleteCharactersInRange:NSMakeRange(0, price.length - 3)];
    }
    NSString *floatVaue = [NSString stringWithFormat:@"%@", str];
    NSArray *arr = @[inteValue,floatVaue];
    return arr;
}

+ (NSArray *)orderStatus:(NSString *)status {
    
    NSArray *arr = @[@"等待付款",@"交易关闭",@"交易完成",@"发货成功",@"购物中",@"订单取消",@"等待发货",@"待申报",@"售后",@"配货中",@"申报异常"];
    /* { "待支付","等待付款"},
    { "待发货","等待发货"},
    { "已发货","发货成功"},
    
    { "已取消","交易关闭"}*/
    NSArray *other = @[@"待支付",@"已取消",@"交易完成",@"已发货",@"购物中",@"订单取消",@"待发货",@"待申报",@"售后",@"配货中",@"申报异常"];
    NSArray *arrImage = @[@"i-4",@"i-3",@"i-1",@"i-2",@"i-6",@"i-3",@"i-5",@"i-2",@"i-2",@"i-2",@"i-2"];
    NSArray * arrMessgae = @[@"未及时付款系统将自动关闭",@"交易关闭，请重拍",@"期待下次光临",@"请买家注意查收包裹",@"请挑选您满意的商品",@"单据取消请重拍",@"请联系卖家发货",@"请等待",@"售后中",@"配货中",@"申报异常"];
    for (int i = 0; i < arr.count; i++) {
       
        if ([arr[i] isEqualToString:status] || [other[i] isEqualToString:status]) {
            return @[arr[i], arrImage[i],arrMessgae[i]];
        }
    }
    status = status ? : @"";
    return @[status, arrImage.lastObject,status];
}

+ (NSAttributedString *)createAttributedStringWithString:(NSString *)string attr:(nullable NSDictionary<NSAttributedStringKey,id> *)attr rang:(NSRange)range{
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:string];
    [aString setAttributes:attr range:range];
    return aString;
}

+ (NSRange)rangeWithStr:(NSString *)str{
    
    NSRange range1 = [str rangeOfString:@"."];
    NSRange range2 = [str rangeOfString:@"¥"];
    NSRange range = NSMakeRange(range2.location + 1 , range1.location - range2.location - 1);
    return range;
}
+ (NSString *)returnMySelfOrEmpytStr:(NSString *)str {
    if (str.length == 0) {
        return @"";
    }
    return str;
}

+ (NSDictionary *)returnNSDictionaryValueIsNULLToEmptyTatgetModel:(NSDictionary *)model{
    __block NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:model];
    [model enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *value = [dicM objectForKey:key];
        if ([value isEqual:[NSNull null]]) {
            [dicM setObject:@"" forKey:key];
        }
    }];
    return dicM;
}

+ (NSString *)getCurrentDeviceMessage{
    
    NSString *message = [NSString stringWithFormat:@"%@%@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion]];
    return message;
}

+ (BOOL)isTelNumber:(NSString *)phoneNum {
    NSString * phone = @"^((400[0-9]{7})|(\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    
    return [regextestmobile evaluateWithObject:phoneNum];
}

 
+ (UIViewController *)findViewController:(UIView *)sourceView {
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

+ (BOOL)isNumberAndalphabet:(NSString *)string{
    
    NSString *number = @"^[A-Za-z0-9]+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [regextestmobile evaluateWithObject:string];
}

+ (BOOL)isdecimals:(NSString *)string{
    NSString *deciamal = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", deciamal];
    return [predicate evaluateWithObject:string];
}

+ (BOOL)isIphoneX{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([machineString isEqualToString:@"iPhone10,3"])return YES;
    if ([machineString isEqualToString:@"iPhone10,6"]) return YES;
    if (SCREEN_HEIGHT == 812)return YES;
    return NO;
}

+ (NSDate *)dateWithString:(NSString *)time formatter:(NSString *)formatter {
    if (StringIsNull(time)) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:time];
}

+ (NSString *)timeWithDate:(NSDate *)date formatter:(NSString *)formatter {
    if (date == nil || [date isKindOfClass:[NSNull class]]) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (CGFloat)getVerticalHeight:(NSString *)string limitWidth:(CGFloat)limitWidth{
    
    return [string boundingRectWithSize:CGSizeMake(limitWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
}

+ (NSString *)getCarPortWithType:(CarType)carType number:(NSInteger)number{
    if (carType == CarType_CarType) {
        switch (number) {
            case 0:
                return @"小型车";
                break;
            case 1:
                return @"中型车";
                break;
            case 2:
                return @"大型车";
                break;
            default:
                return @"";
                break;
        }
    }else{
        switch (number) {
            case 1:
                return @"车库";
                break;
            case 2:
                return @"停车场";
                break;
            case 3:
                return @"路边车位";
                break;
            default:
                return @"";
                break;
        }
    }
}


@end
