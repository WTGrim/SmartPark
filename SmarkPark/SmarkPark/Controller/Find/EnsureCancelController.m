//
//  EnsureCancelController.m
//  SmarkPark
//
//  Created by SandClock on 2018/3/19.
//  Copyright © 2018年 SmartPark. All rights reserved.
//

#import "EnsureCancelController.h"

@interface EnsureCancelController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *ensureCancel;
@property (weak, nonatomic) IBOutlet UILabel *reasonTip;

@property(nonatomic, strong)NSArray *dataArr;

@end

static NSString *const kCancelTip = @"请选择取消原因";

@implementation EnsureCancelController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)setupUI{
    
    self.title = @"取消停车";
    _textView.delegate = self;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableView.layer.borderWidth = 0.5f;
    _tableView.layer.cornerRadius = 5;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.transform = CGAffineTransformMakeScale(1.0f, 0.01f);
    _tableView.layer.anchorPoint = CGPointMake(0.5, 0.0);
    _tableView.layer.shadowColor = [UIColor blackColor].CGColor;
    _tableView.layer.shadowOffset = CGSizeMake(5, 5);
    _tableView.layer.shadowOpacity = 0.8;
    _tableView.layer.shadowRadius = 2;
    
    _dataArr = @[@"临时改变行程，不停了", @"点错了，误点预定按钮", @"距离太远，不想停了", @"车位信息错误，不能停", @"到达车位，车位不能在指定时间空闲出来", @"联系不到车主，停不了", @"停车场限进入，停不了"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor darkGrayColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _tips.text = _dataArr[indexPath.row];
    [self hiddenDownListTable];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)hiddenDownListTable {
    [UIView animateWithDuration:0.25 animations:^{
        _tableView.transform = CGAffineTransformMakeScale(1.0f, 0.01f);
    } completion:^(BOOL finished) {
        if (finished) {
            _tableView.hidden = YES;
        }
    }];
}

- (void)showDownListTable {
    _tableView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _tableView.transform = CGAffineTransformIdentity;
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _tips.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        _tips.hidden = NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if (StringIsNull(textView.text)) {
            _tips.hidden = NO;
        }
        return YES;
    }
    
    NSString *resultStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (StringIsNull(resultStr)) {
        _tips.hidden = NO;
    }else {
        _tips.hidden = YES;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *toBeString = textView.text;
    NSString *lang = textView.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > 200) {
                textView.text = [toBeString substringToIndex:200];
            }
            _limitLabel.text = [NSString stringWithFormat:@"%lu",200 - textView.text.length];
        }
    }else {
        if (toBeString.length > 200) {
            textView.text = [toBeString substringToIndex:200];
        }
        _limitLabel.text = [NSString stringWithFormat:@"%lu",200 - textView.text.length];
    }
}

#pragma mark - 确认取消
- (IBAction)ensureClick:(UIButton *)sender {
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
    
    if ([_reasonTip.text isEqualToString:kCancelTip] && _textView.text.length <= 0) {
        [AlertView showMsg:@"请选择或者填写取消原因" duration:2];
        return ;
    }
    
    if (_textView.text.length > 0 && _textView.text.length <= 200) {
        
        //确认取消
        
    }else{
        [AlertView showMsg:@"字数长度超出200字" duration:2];
    }
}


@end
