//
//  RelayoutButton.h
//  JXBFineEx
//
//  Created by 赵宇 on 19/01/2018.
//  Copyright © 2018 Fineex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelayoutButton : UIButton

@end

@interface ImageOnTextBadgeButton : UIButton
@property (assign ,nonatomic) NSInteger badgeNumber;
@end;

@interface BadgeValueButton : UIButton
@property (copy, nonatomic) NSString *badgeValue;
@end

@interface ShopCartButton: UIButton
@property (nonatomic, assign) NSInteger badgeNumber;
@end

@interface SearchShopCartButton: UIButton
@property (nonatomic, assign) NSInteger badgeNumber;
@end

@interface LargerButton : UIButton

@end

