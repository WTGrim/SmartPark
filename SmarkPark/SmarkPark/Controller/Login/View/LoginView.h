//
//  LoginView.h
//  SmarkPark
//
//  Created by SandClock on 2018/3/8.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoginBtnType) {
    LoginBtnType_Login,
    LoginBtnType_FindPsd,
};

@interface LoginView : UIView

@property(nonatomic, copy)void(^loginBtnClick)(LoginBtnType type);

@end
