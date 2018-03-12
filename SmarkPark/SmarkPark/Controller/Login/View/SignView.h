//
//  SignView.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/8.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SignBtnType) {
    SignBtnType_Sign,
    SignBtnType_Code,
    SignBtnType_Protocol,
};
@interface SignView : UIView

@property(nonatomic, copy)void(^signBtnClick)(SignBtnType type);

@end
