//
//  LoginView.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "LoginView.h"
#import "LoginViewModel.h"

@interface LoginView()
@property(nonatomic,strong) LoginViewModel *viewModel;
@property(nonatomic,strong) UITextField *phoneField;
@property(nonatomic,strong) UITextField *pwdField;
@property(nonatomic,strong) UIButton *sumbit;
@property(nonatomic,strong) UIButton *forget;
@end
@implementation LoginView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel {
    self.viewModel = (LoginViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews {
    [self addSubview:self.phoneField];
    [self addSubview:self.pwdField];
    [self addSubview:self.sumbit];
    [self addSubview:self.forget];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints {
    [super updateConstraints];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH -40, 40));
    }];
    [self.pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.phoneField.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH -40, 40));
    }];
    [self.sumbit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.pwdField.mas_bottom).with.offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-40, 40));
    }];
    [self.forget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.sumbit.mas_bottom).with.offset(20);
        make.size.mas_offset(CGSizeMake(100, 30));
    }];
}
-(void)bindViewModel {
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UITextField *)pwdField{
    if (!_pwdField) {
        _pwdField = [[UITextField alloc] init];
        _pwdField.placeholder = @"输入密码";
        _pwdField.font = [UIFont systemFontOfSize:14];
        _pwdField.backgroundColor = [UIColor whiteColor];
        _pwdField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
        _pwdField.leftView.userInteractionEnabled = NO;
        _pwdField.leftViewMode = UITextFieldViewModeAlways;
        _pwdField.secureTextEntry = YES;
    }
    return _pwdField;
}

-(UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [[UITextField alloc] init];
        _phoneField.placeholder = @"输入手机号";
        _phoneField.font = [UIFont systemFontOfSize:14];
        _phoneField.backgroundColor = [UIColor whiteColor];
        _phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
        _phoneField.leftView.userInteractionEnabled = NO;
        _phoneField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneField;
}
-(UIButton *)sumbit{
    if (!_sumbit) {
        _sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
        _sumbit.backgroundColor = DEFAULT_COLOR;
        [_sumbit setTitle:@"登录" forState:UIControlStateNormal];
        [_sumbit setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        _sumbit.layer.masksToBounds = YES;
        _sumbit.layer.cornerRadius = 3;
        @weakify(self)
        [[_sumbit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (![HNUesrInformation valiMobile:self.phoneField.text]) {
                showMassage(@"请填写正确的手机号码")
                return ;
            }
            if (self.pwdField.text.length < 6){
                showMassage(@"密码不得小于6位数字")
                return ;
            }
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:self.phoneField.text forKey:@"phone"];
            [param setObject:self.pwdField.text forKey:@"password"];
            self.viewModel.phone = self.phoneField.text;
            [self.viewModel.loginRequestCommand execute:param];
        }];
    }
    return _sumbit;
}
-(UIButton *)forget {
    if (!_forget) {
        _forget = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"忘记密码?" attributes:dic];
        [_forget setAttributedTitle:att forState:UIControlStateNormal];
        [_forget.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        @weakify(self)
        [[_forget rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.forgetClickSubject sendNext:nil];
        }];
    }
    return _forget;
}
@end
