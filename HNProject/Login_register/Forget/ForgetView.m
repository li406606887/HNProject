//
//  ForgetView.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ForgetView.h"
#import "ForgetViewModel.h"
#import "ForgetModel.h"

@interface ForgetView()
@property(nonatomic,strong) ForgetViewModel *viewModel;
@property(nonatomic,strong) UITextField *phoneField;
@property(nonatomic,strong) UITextField *codeField;
@property(nonatomic,strong) UITextField *pwdField;
@property(nonatomic,strong) UITextField *repeatPwdField;
@property(nonatomic,strong) UILabel *sendCode;
@property(nonatomic,strong) UIButton *sumbit;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) ForgetModel *model;
@property(nonatomic,assign) int seconds;
@end


@implementation ForgetView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (ForgetViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews {
    [self addSubview:self.phoneField];
    [self addSubview:self.codeField];
    [self addSubview:self.pwdField];
    [self addSubview:self.repeatPwdField];
    [self addSubview:self.sendCode];
    [self addSubview:self.sumbit];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    [super updateConstraints];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.phoneField.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
    [self.pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.codeField.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
    [self.repeatPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.pwdField.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
    [self.sendCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeField);
        make.right.equalTo(self.codeField.mas_right).with.offset(-2);
        make.size.mas_offset(CGSizeMake(80, 30));
    }];
    
    [self.sumbit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.repeatPwdField.mas_bottom).with.offset(20);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
}



-(void)timerAddCount{
    self.seconds++;
    if (self.seconds>60) {
        [self.timer invalidate];
        self.timer = nil;
        self.seconds = 0;
        self.sendCode.text = @"发送验证码";
        self.sendCode.userInteractionEnabled = YES;
    }else{
        self.sendCode.text = [NSString stringWithFormat:@"%d秒",60-self.seconds];
        self.sendCode.userInteractionEnabled = NO;
    }
}
-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.verificationCodeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(timerAddCount)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self.timer fire];
    }];
}




-(UITextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[UITextField alloc] init];
        _phoneField.placeholder = @"请输入手机号码";
        _phoneField.font = [UIFont systemFontOfSize:14];
        [_phoneField.leftView setUserInteractionEnabled:NO];
        _phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
        _phoneField.leftViewMode = UITextFieldViewModeAlways;
        _phoneField.backgroundColor = [UIColor whiteColor];
        @weakify(self)
        [[_phoneField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.model.phone = x;
        }];

    }
    return _phoneField;
}
-(UITextField *)codeField {
    if (!_codeField) {
        _codeField = [[UITextField alloc] init];
        _codeField.placeholder = @"请输入验证码";
        _codeField.font = [UIFont systemFontOfSize:14];
        [_codeField.leftView setUserInteractionEnabled:NO];
        _codeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
        _codeField.leftViewMode = UITextFieldViewModeAlways;
        _codeField.backgroundColor = [UIColor whiteColor];
    }
    return _codeField;
}
-(UITextField *)pwdField {
    if (!_pwdField) {
        _pwdField = [[UITextField alloc] init];
        _pwdField.placeholder = @"请输入新密码";
        _pwdField.font = [UIFont systemFontOfSize:14];
        [_pwdField.leftView setUserInteractionEnabled:NO];
        _pwdField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
        _pwdField.leftViewMode = UITextFieldViewModeAlways;
        _pwdField.backgroundColor = [UIColor whiteColor];
        @weakify(self)
        [[_pwdField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.model.password = x;
        }];
    }
    return _pwdField;
}

-(UITextField *)repeatPwdField {
    if (!_repeatPwdField) {
        _repeatPwdField = [[UITextField alloc] init];
        _repeatPwdField.placeholder = @"请重复新密码";
        _repeatPwdField.font = [UIFont systemFontOfSize:14];
        [_repeatPwdField.leftView setUserInteractionEnabled:NO];
        _repeatPwdField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
        _repeatPwdField.leftViewMode = UITextFieldViewModeAlways;
        _repeatPwdField.backgroundColor = [UIColor whiteColor];
        @weakify(self)
        [[_repeatPwdField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.model.repassword = x;
        }];
    }
    return _repeatPwdField;
}

-(UILabel *)sendCode {
    if (!_sendCode) {
        _sendCode = [[UILabel alloc] init];
        _sendCode.text = @"发送验证码";
        _sendCode.font = [UIFont systemFontOfSize:14];
        _sendCode.textAlignment = NSTextAlignmentCenter;
        _sendCode.backgroundColor = DEFAULT_COLOR;
        _sendCode.layer.masksToBounds = YES;
        _sendCode.layer.cornerRadius = 2;
        _sendCode.userInteractionEnabled = YES;
        @weakify(self)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self)
            if (![HNUesrInformation valiMobile:self.phoneField.text]) {
                showMassage(@"请输入正确的手机号码");
                return;
            }
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:self.model.phone forKey:@"phone"];
            NSString *code = [NSString stringWithFormat:@"%d",(arc4random() % 899999)+100000];
            [param setObject:code forKey:@"code"];
            [self.viewModel.verificationCodeCommand execute:param];
            self.model.code = code;
        }];
        [_sendCode addGestureRecognizer:tap];
    }
    return _sendCode;
}
-(UIButton *)sumbit {
    if (!_sumbit) {
        _sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sumbit setTitle:@"确认" forState:UIControlStateNormal];
        [_sumbit setBackgroundColor:DEFAULT_COLOR];
        [_sumbit.titleLabel setFont: [UIFont systemFontOfSize:14]];
        _sumbit.layer.masksToBounds = YES;
        _sumbit.layer.cornerRadius = 3;
        [[_sumbit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.model.phone.length!=11) {
                showMassage(@"请输入正确的手机号码");
                return ;
            }
            if (![self.model.repassword isEqualToString:self.model.password]) {
                showMassage(@"两次密码输入不一致");
                return ;
            }
            if (![self.model.code isEqualToString:self.codeField.text]) {
                showMassage(@"请输入正确的验证码");
                return ;
            }
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:self.model.phone forKey:@"phone"];
            [param setObject:self.model.password forKey:@"password"];
            [param setObject:self.model.repassword forKey:@"repassword"];
            [param setObject:self.model.code forKey:@"code"];
            [self.viewModel.sumbitDataCommand execute:param];
        }];
    }
    return _sumbit;
}
-(ForgetModel *)model{
    if (!_model) {
        _model = [[ForgetModel alloc] init];
    }
    return _model;
}
-(int)seconds{
    if (!_seconds) {
        _seconds = 0;
    }
    return _seconds;
}
@end
