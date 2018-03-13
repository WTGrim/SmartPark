//
//  RelayoutButton.m
//  JXBFineEx
//
//  Created by 赵宇 on 19/01/2018.
//  Copyright © 2018 Fineex. All rights reserved.
//

#import "RelayoutButton.h"

@implementation RelayoutButton

@end

@interface ImageOnTextBadgeButton()
{
    UILabel *badgeLabel;
}
@end

@implementation ImageOnTextBadgeButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createBadgeLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createBadgeLabel];
    }
    return self;
}

- (void)createBadgeLabel {
    badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    badgeLabel.layer.cornerRadius = 8;
    badgeLabel.clipsToBounds = YES;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = [UIFont boldSystemFontOfSize:9];
    badgeLabel.hidden = YES;
    badgeLabel.backgroundColor = ThemeColor_RedText;
    badgeLabel.layer.borderColor = ThemeColor_RedText.CGColor;
    badgeLabel.layer.borderWidth = 1.5f;
    [self addSubview:badgeLabel];
}

- (void)setBadgeNumber:(NSInteger)badgeNumber {
    _badgeNumber = badgeNumber;
    if (badgeNumber == 0) {
        badgeLabel.text = @"0";
        badgeLabel.hidden = YES;
    }else {
        badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)_badgeNumber];
        badgeLabel.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!StringIsNull(self.currentTitle)) {
        CGRect frame = self.frame;
        CGRect imgFrame = self.imageView.frame;
        imgFrame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
        self.imageView.frame = imgFrame;
        self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - imgFrame.size.height * 0.5);
        
        CGRect labelFrame = self.titleLabel.frame;
        labelFrame = CGRectMake(0, CGRectGetMidY(self.bounds) + 8, frame.size.width, 14);
        self.titleLabel.frame = labelFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    CGRect frame = self.imageView.frame;
    badgeLabel.frame = CGRectMake(frame.origin.x + frame.size.width - 8, frame.origin.y - 6, 16, 16);
}

@end

@interface BadgeValueButton()
{
    UILabel *badgeLabel;
}
@end


@implementation BadgeValueButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createBadgeLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createBadgeLabel];
    }
    return self;
}

- (void)createBadgeLabel {
    badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 12, 0, 16, 16)];
    badgeLabel.layer.cornerRadius = 8;
    badgeLabel.clipsToBounds = YES;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = [UIFont boldSystemFontOfSize:9];
    badgeLabel.hidden = YES;
    badgeLabel.backgroundColor = ThemeColor_RedText;
    badgeLabel.layer.borderColor = ThemeColor_RedText.CGColor;
    badgeLabel.layer.borderWidth = 1.5f;
    [self addSubview:badgeLabel];
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    if (StringIsNull(_badgeValue) || [badgeValue integerValue] == 0) {
        badgeLabel.text = @"0";
        badgeLabel.hidden = YES;
    }else {
        badgeLabel.text = _badgeValue;
        badgeLabel.hidden = NO;
    }
}

@end


@interface ShopCartButton()


@end

@implementation ShopCartButton{
    UILabel *badgeLabel;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self createBadgeLabel];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBadgeLabel];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self createBadgeLabel];
    }
    return self;
}

- (void)createBadgeLabel{
    badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 12, 0, 16, 16)];
    badgeLabel.layer.cornerRadius = 8;
    badgeLabel.clipsToBounds = YES;
    badgeLabel.backgroundColor = ThemeColor_RedText;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = [UIFont boldSystemFontOfSize:9];
    badgeLabel.hidden = YES;
    [self addSubview:badgeLabel];
}

- (void)setBadgeNumber:(NSInteger)badgeNumber{
    _badgeNumber = badgeNumber;
    if (badgeNumber == 0) {
        badgeLabel.text = @"0";
        badgeLabel.hidden = YES;
    }else {
        badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)_badgeNumber];
        badgeLabel.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!StringIsNull(self.currentTitle)) {
        CGRect frame = self.frame;
        CGRect imgFrame = self.imageView.frame;
        imgFrame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
        self.imageView.frame = imgFrame;
        self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - imgFrame.size.height * 0.2);
        
        CGRect labelFrame = self.titleLabel.frame;
        labelFrame = CGRectMake(0, CGRectGetMidY(self.bounds) + 8, frame.size.width, 14);
        self.titleLabel.frame = labelFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    CGRect frame = self.imageView.frame;
    badgeLabel.frame = CGRectMake(frame.origin.x + frame.size.width - 8, frame.origin.y - 6, 16, 16);
}


@end




@interface SearchShopCartButton ()
@end

@implementation SearchShopCartButton{
    UILabel *badgeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createBadgeLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createBadgeLabel];
    }
    return self;
}

- (void)createBadgeLabel {
    badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 12, 0, 16, 16)];
    badgeLabel.layer.cornerRadius = 8;
    badgeLabel.clipsToBounds = YES;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.textColor = ThemeColor_RedText;
    badgeLabel.font = [UIFont boldSystemFontOfSize:8];
    badgeLabel.hidden = YES;
    badgeLabel.layer.borderColor = ThemeColor_RedText.CGColor;
    badgeLabel.layer.borderWidth = 1.5f;
    [self addSubview:badgeLabel];
}

- (void)setBadgeNumber:(NSInteger)badgeNumber{
    _badgeNumber = badgeNumber;
    if (badgeNumber == 0) {
        badgeLabel.text = @"0";
        badgeLabel.hidden = YES;
    }else {
        badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)_badgeNumber];
        badgeLabel.hidden = NO;
    }
}
 
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!StringIsNull(self.currentTitle)) {
        CGRect frame = self.frame;
        CGRect imgFrame = self.imageView.frame;
        imgFrame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
        self.imageView.frame = imgFrame;
        self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - imgFrame.size.height * 0.2);
        
        CGRect labelFrame = self.titleLabel.frame;
        labelFrame = CGRectMake(0, CGRectGetMidY(self.bounds) + 8, frame.size.width, 14);
        self.titleLabel.frame = labelFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    CGRect frame = self.imageView.frame;
    badgeLabel.frame = CGRectMake(frame.origin.x + frame.size.width - 12, frame.origin.y - 3, 16, 16);
}


@end

@implementation LargerButton

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end

