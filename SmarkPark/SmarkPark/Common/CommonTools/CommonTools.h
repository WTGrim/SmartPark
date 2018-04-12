//
//  CommonTools.h
//  FineexFQXD
//
//  Created by ZhaoYu on 10/8/16.
//  Copyright © 2016 FineEx. All rights reserved.
//




#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CarType) {
    CarType_CarType,
    CarType_CarPortType,
};

@interface CommonTools : NSObject
//判断输入框是否为空
+ (BOOL)isTextFieldHasInputed:(UITextField *)textField;
//设置imageView的图片
+ (void)setImageWithURL:(NSString *)urlStr imageVIew:(UIImageView *)imageView;
//计算两个时间的时间差，返回数组元素分别表示为0:天 1:时 2:分 3:秒
+ (NSArray *)caculateDateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
//计算两个时间的时间差，返回数组元素分别表示为 0:时 1:分 2:秒
+ (NSArray *)caculateHourDateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

+ (NSString *)caculateTimeDistanceWithTime:(NSString *)time;
//获取字符串的size
+ (CGRect)getTextRectWithString:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;
//保存对象到本地
+(void)saveLocalWithKey:(NSString*)key Obj:(id)obj;
//从本地读取对象
+(id)loadLocalWithKey:(NSString*)key;
//删除本地对象
+(void)removeLocalWithKey:(NSString*)key;

//设置价格的属性字符串
+ (NSAttributedString *)getPriceAttributedStringWithString:(NSString *)priceStr;
/** ------ */
+ (NSAttributedString *)dsperson_addPriceLabelThroughtLine:(NSString *)title;
+ (NSAttributedString *)getCommonPriceAttributedStringWithString:(NSString *)priceStr bigFont:(CGFloat)bigFont smallFont:(CGFloat)smallFont;

+ (CGSize)convertSizeToScreenWithSize:(CGSize)size;

BOOL StringIsNull(NSString *string);
+ (NSString *)nullToString:(NSString *)string;

NSString* DeleteWitheAndSpace(NSString *string);

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 * func: 将价格分成整数和小数
 */
+(NSArray *)priceToIntAndFolat:(NSString *)price;
/**
 * func: 根据状态返回图片 
 * 数组 0 - 图片 1 为信息
 */
+ (NSArray *)orderStatus:(NSString *)status;

//设置价格显示方式的富文本
+ (NSAttributedString *)createAttributedStringWithString:(NSString *)string attr:(nullable NSDictionary<NSAttributedStringKey,id> *)attr rang:(NSRange)range;

+ (NSRange)rangeWithStr:(NSString *)str;

+ (NSString *)returnMySelfOrEmpytStr:(NSString *)str;

BOOL chargeIdIsNullOrEmpty(id obj);
/**
 将字典中中key值为NULL 返回@"";
 
 @param model 目标字典
 */
+ (NSDictionary *)returnNSDictionaryValueIsNULLToEmptyTatgetModel:(NSDictionary *)model;


//获取设备类型信息

+ (NSString *)getCurrentDeviceMessage;
+ (NSAttributedString *)getMineGroupPriceAttributedStringWithString:(NSString *)priceStr;

//检查是否为电话
+ (BOOL)isTelNumber:(NSString *)phoneNum;


+ (UIViewController *)findViewController:(UIView *)sourceView;

//判断是数字和字符
+ (BOOL)isNumberAndalphabet:(NSString *)string;

//判断是整数或者小数
+ (BOOL)isdecimals:(NSString *)string;

/**
 string to date

 @param stringDate string eg: 2017 10:10:10
 @return NSDate
 */
+ (NSDate *)dsperson_cacluteStringToDate:(NSString *)stringDate;

/**
 比较时间前后

 @param first NSDate
 @param second NSDate
 @return BOOL YES is < ; NO is >
 */
+ (BOOL)dsperson_timeInterval:(NSDate *_Nonnull)first second:(NSDate *_Nullable)second;

//判断是否是iPhone X
+ (BOOL)isIphoneX;

//根据格式获取日期
+ (NSDate *_Nullable)dateWithString:(NSString *)time formatter:(NSString *)formatter;
//根据格式获取时间字符串
+ (NSString *)timeWithDate:(NSDate *)date formatter:(NSString *)formatter;

+ (CGFloat)getVerticalHeight:(NSString *)string limitWidth:(CGFloat)limitWidth;

+ (NSString *)getCarPortWithType:(CarType)carType number:(NSInteger)number;
//计算取消和还
+ (NSArray *)caculateTimeWithInterval:(NSInteger)interval;
@end
