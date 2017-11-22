//
//  RegisterView.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "RegisterView.h"
#import "RegisterViewModel.h"
#import "RegisterModel.h"

#define kSubViewWidth SCREEN_WIDTH-30

@interface RegisterView()
@property(nonatomic,strong) RegisterViewModel *viewModel;
@property(nonatomic,strong) UIScrollView *scroll;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UITextField *pwdField;//密码
@property(nonatomic,strong) UITextField *repeatPwdField;//重复密码
@property(nonatomic,strong) UITextField *taoBaoAccount;//淘宝账号
@property(nonatomic,strong) UITextField *qqAccount;//qq账号
@property(nonatomic,strong) UITextField *wechat;//qq账号
@property(nonatomic,strong) UITextField *name;//姓名
@property(nonatomic,strong) UITextField *inviteCode;//邀请人
@property(nonatomic,strong) UITextField *inviterRelationship;//和邀请人的关系
@property(nonatomic,strong) UITextField *phoneField;//手机
@property(nonatomic,strong) UITextField *codeField;//验证码
@property(nonatomic,strong) UILabel *sendCode;//发送验证码
@property(nonatomic,strong) UILabel *cityLabel; //城市
@property(nonatomic,strong) UIButton *province; //城市
@property(nonatomic,strong) UIButton *city; //城市
@property(nonatomic,strong) UIView *agreementView;
@property(nonatomic,strong) UIButton *agreement;//用户协议
@property(nonatomic,strong) UIButton *agreedAgreement;//同意用户协议
@property(nonatomic,strong) UIButton *sumbit;//提交
@property(nonatomic,strong) RegisterModel *model;
@property(nonatomic,strong) NSMutableArray *cityArray;
@property(nonatomic,strong) NSMutableArray *provinceArray;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) int seconds;
@end

@implementation RegisterView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel {
    self.viewModel = (RegisterViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews {
    [self addSubview:self.scroll];
    [self.scroll addSubview:self.backView];
    [self.backView addSubview:self.pwdField];
    [self.backView addSubview:self.repeatPwdField];
    [self.backView addSubview:self.taoBaoAccount];
    [self.backView addSubview:self.qqAccount];
    [self.backView addSubview:self.name];
    [self.backView addSubview:self.wechat];
    [self.backView addSubview:self.inviteCode];
    [self.backView addSubview:self.inviterRelationship];
    [self.backView addSubview:self.phoneField];
    [self.backView addSubview:self.codeField];
    [self.backView addSubview:self.cityLabel];
    [self.backView addSubview:self.province];
    [self.backView addSubview:self.city];
    [self.backView addSubview:self.agreementView];
    [self.backView addSubview:self.sendCode];
    [self.agreementView addSubview:self.agreement];
    [self.agreementView addSubview:self.agreedAgreement];
    [self.backView addSubview:self.sumbit];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.scroll).with.offset(20);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 530));
    }];
    [self.pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.backView);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.repeatPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.pwdField.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.taoBaoAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.repeatPwdField.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.qqAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.taoBaoAccount.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.qqAccount.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.name.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.province mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cityLabel);
        make.right.equalTo(self.city.mas_left).with.offset(-5);
        make.size.mas_offset(CGSizeMake(80, 30));
    }];
    
    [self.city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cityLabel);
        make.right.equalTo(self.backView.mas_right).with.offset(-5);
        make.size.mas_offset(CGSizeMake(80, 30));
    }];
    [self.province mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cityLabel);
        make.right.equalTo(self.city.mas_left).with.offset(-5);
        make.size.mas_offset(CGSizeMake(80, 30));
    }];
    
    [self.wechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityLabel.mas_bottom).with.offset(1);
        make.centerX.equalTo(self.backView);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.wechat.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.inviterRelationship mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.inviteCode.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.inviterRelationship.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.phoneField.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.sendCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeField);
        make.right.equalTo(self.codeField.mas_right).with.offset(-5);
        make.size.mas_offset(CGSizeMake(80, 30));
    }];
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeField.mas_bottom).with.offset(1);
        make.centerX.equalTo(self.backView);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
    }];
    [self.agreedAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeField.mas_bottom).with.offset(10);
        make.left.equalTo(self.agreementView);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [self.agreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeField.mas_bottom).with.offset(10);
        make.left.equalTo(self.agreedAgreement.mas_right).with.offset(10);
        make.size.mas_offset(CGSizeMake(kSubViewWidth-40, 30));
    }];
    [self.sumbit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreementView.mas_bottom);
        make.centerX.equalTo(self.backView);
        make.size.mas_offset(CGSizeMake(kSubViewWidth, 40));
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
    [self.viewModel.getVerificationCodeSubject subscribeNext:^(id  _Nullable x) {
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
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] init];
        _scroll.contentSize = CGSizeMake(0.5f, 600);
    }
    return _scroll;
}
-(UIView *)backView {
    if (!_backView ) {
        _backView = [[UIView alloc] init];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 3;
    }
    return _backView;
}
-(UITextField *)pwdField {
    if (!_pwdField) {
        _pwdField = [self creatTextfield];
        _pwdField.placeholder = @"请输入密码";
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
        _repeatPwdField = [self creatTextfield];
        _repeatPwdField.placeholder = @"请重复密码";
        
    }
    return _repeatPwdField;
}
-(UITextField *)taoBaoAccount {
    if (!_taoBaoAccount) {
        _taoBaoAccount = [self creatTextfield];
        _taoBaoAccount.placeholder = @"请输入淘宝账号";
        UILabel *prompt = [[UILabel alloc] init];
        prompt.text = @"请真实填写,以便工作人员审核";
        prompt.font = [UIFont systemFontOfSize:10];
        [_taoBaoAccount addSubview:prompt];
        [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_taoBaoAccount);
            make.right.equalTo(_taoBaoAccount.mas_right);
            make.size.mas_offset(CGSizeMake(140, 20));
        }];
        @weakify(self)
        [[_taoBaoAccount rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.model.taobao_id = x;
        }];
    }
    return _taoBaoAccount;
}
-(UITextField *)qqAccount {
    if (!_qqAccount) {
        _qqAccount = [self creatTextfield];
        _qqAccount.placeholder = @"请输入QQ账号";
        UILabel *prompt = [[UILabel alloc] init];
        prompt.text = @"请真实填写,以便工作人员审核";
        prompt.font = [UIFont systemFontOfSize:10];
        [_qqAccount addSubview:prompt];
        [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_qqAccount);
            make.right.equalTo(_qqAccount.mas_right).with.offset(-2);
            make.size.mas_offset(CGSizeMake(140, 20));
        }];
        @weakify(self)
        [[_qqAccount rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.model.qq = x;
        }];
    }
    return _qqAccount;
}
-(UITextField *)wechat {
    if (!_wechat) {
        _wechat = [self creatTextfield];
        _wechat.placeholder = @"请输入微信号";
        @weakify(self)
        [[_wechat rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.model.wechat = x;
        }];
    }
    return _wechat;
}

-(UITextField *)name {
    if (!_name) {
        _name = [self creatTextfield];
        _name.placeholder = @"请输入姓名";
        @weakify(self)
        [[_name rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.model.real_name = x;
        }];
    }
    return _name;
}
-(UITextField *)inviteCode {
    if (!_inviteCode) {
        _inviteCode = [self creatTextfield];
        _inviteCode.placeholder = @"请输入邀请码";
        @weakify(self)
        [[_inviteCode rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.model.inviter_id = x;
        }];
    }
    return _inviteCode;
}
-(UITextField *)inviterRelationship {
    if (!_inviterRelationship) {
        _inviterRelationship = [self creatTextfield];
        _inviterRelationship.placeholder = @"请输入与邀请的关系";
        @weakify(self)
        [[_inviterRelationship rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.model.invite_relationship = x;
        }];
    }
    return _inviterRelationship;
}
-(UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [self creatTextfield];
        _phoneField.placeholder = @"请输入手机号码";
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
        _codeField = [self creatTextfield];
        _codeField.placeholder = @"请输入验证码";
    }
    return _codeField;
}
-(UILabel *)sendCode {
    if (!_sendCode) {
        _sendCode = [[UILabel alloc] init];
        _sendCode.text = @"发送验证码";
        _sendCode.backgroundColor = DEFAULT_COLOR;
        _sendCode.textAlignment = NSTextAlignmentCenter;
        _sendCode.font = [UIFont systemFontOfSize:13];
        _sendCode.layer.masksToBounds = YES;
        _sendCode.layer.cornerRadius = 3;
        _sendCode.userInteractionEnabled = YES;
        @weakify(self)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self)
            if (self.model.phone.length!=11) {
                showMassage(@"请输入正确的手机号码");
                return;
            }
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:self.model.phone forKey:@"phone"];
            NSString *code = [NSString stringWithFormat:@"%d",(arc4random() % 899999)+100000];
            [param setObject:code forKey:@"code"];
            [self.viewModel.getVerificationCodeCommand execute:param];
            self.model.code = code;
        }];
        [_sendCode addGestureRecognizer:tap];
    }
    return _sendCode;
}
-(UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.text = @"  所在城市";
        _cityLabel.font = [UIFont systemFontOfSize:14];
        _cityLabel.backgroundColor = [UIColor whiteColor];
    }
    return _cityLabel;
}
-(UIButton *)province {
    if (!_province) {
        _province = [self getCityButtonState];
        [_province setTitle:@"选择省份" forState:UIControlStateNormal];
        [_province setImage:[UIImage imageNamed:@"Register_Provinces_Choose_DropDown"] forState:UIControlStateNormal];
        @weakify(self)
        [[_province rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [PopoverView showPopoverViewAtPoint:CGPointZero withWidth:280 withMenuItems:self.provinceArray];
        }];
    }
    return _province;
}
-(UIButton *)city {
    if (!_city) {
        _city = [self getCityButtonState];
        [_city setTitle:@"选择城市" forState:UIControlStateNormal];
        [_city.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_city setImage:[UIImage imageNamed:@"Register_Provinces_Choose_DropDown"] forState:UIControlStateNormal];
        @weakify(self)
        [[_city rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.cityArray.count<1) {
                showMassage(@"暂无城市信息")
                return ;
            }
            [PopoverView showPopoverViewAtPoint:CGPointZero withWidth:280 withMenuItems:self.cityArray];
        }];
    }
    return _city;
}

-(UIButton *)agreement{
    if (!_agreement) {
        _agreement = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:RGB(134, 134, 134)};
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我已经阅读并认可协议条款《用户协议》" attributes:dic];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(12, 6)];
        [_agreement setAttributedTitle:string forState:UIControlStateNormal];
        @weakify(self)
        [[_agreement rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.userAgreementClickSubject sendNext:nil];
        }];
    }
    return _agreement;
}
-(UIView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[UIView alloc] init];
        _agreementView.backgroundColor = [UIColor whiteColor];
    }
    return _agreementView;
}
-(UIButton *)agreedAgreement{
    if (!_agreedAgreement) {
        _agreedAgreement = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreedAgreement setImage:[UIImage imageNamed:@"Register_Agreement_Normal"] forState:UIControlStateNormal];
        [_agreedAgreement setImage:[UIImage imageNamed:@"Register_Agreement_Selected"] forState:UIControlStateSelected];
        @weakify(self)
        _agreedAgreement.selected = YES;
        [[_agreedAgreement rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            _agreedAgreement.selected = !_agreedAgreement.selected;
            if (_agreedAgreement.selected == NO){
                self.sumbit.userInteractionEnabled = NO;
                self.sumbit.backgroundColor = [UIColor lightGrayColor];
            }else {
                self.sumbit.userInteractionEnabled = YES;
                self.sumbit.backgroundColor = DEFAULT_COLOR;
            }
        }];
    }
    return _agreedAgreement;
}
-(UIButton *)sumbit {
    if (!_sumbit) {
        _sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sumbit setTitle:@"确认注册" forState:UIControlStateNormal];
        [_sumbit setBackgroundColor:DEFAULT_COLOR];
        _sumbit.layer.masksToBounds = YES;
        _sumbit.layer.cornerRadius = 3;
        @weakify(self)
        [[_sumbit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.model.password.length<6) {
                showMassage(@"请输入6位以上的密码");
                return ;
            }else if (![self.model.password isEqualToString:self.repeatPwdField.text]){
                showMassage(@"两次密码不一致");
                return ;
            }else if (![HNUesrInformation valiMobile:self.phoneField.text]){
                showMassage(@"请输入正确的手机号码");
                return ;
            }else if(self.model.real_name.length<1){
                showMassage(@"请输入真实姓名");
                return ;
            }else if(self.model.inviter_id.length<1){
                showMassage(@"请输入邀请码");
                return ;
            }else if(self.model.invite_relationship.length<1){
                showMassage(@"请输入邀请人关系");
                return ;
            }else if(self.model.province.length<1){
                showMassage(@"请选择省份");
                return ;
            }else if(self.model.city.length<1){
                showMassage(@"请选择城市");
                return ;
            }else if(self.model.qq.length<6){
                showMassage(@"请输入正确的QQ号码");
                return ;
            }else if(self.model.taobao_id.length<1){
                showMassage(@"请输入淘宝号码");
                return ;
            }else if(![self.model.code isEqualToString:self.codeField.text]){
                showMassage(@"请核对验证码");
                return ;
            }else if(self.model.wechat.length<1){
                showMassage(@"请输入微信号");
                return ;
            }
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:self.model.phone forKey:@"phone"];
            [param setObject:self.model.password forKey:@"password"];
            [param setObject:self.model.taobao_id forKey:@"taobao_id"];
            [param setObject:self.model.qq forKey:@"qq"];
            [param setObject:self.model.real_name forKey:@"real_name"];
            [param setObject:self.model.province forKey:@"province"];
            [param setObject:self.model.city forKey:@"city"];
            [param setObject:self.model.inviter_id forKey:@"inviter_id"];
            [param setObject:self.model.invite_relationship forKey:@"invite_relationship"];
            [param setObject:self.model.wechat forKey:@"wechat"];
            [self.viewModel.registerSuccessfulClickCommand execute:param];
        }];
    }
    return _sumbit;
}

-(NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [[NSMutableArray alloc] init];
        for (NSString *title in self.viewModel.provinces) {
            MenuItem *item = [[MenuItem alloc] init];
            item.title = title;
            @weakify(self)
            item.selectItemBlock = ^(MenuItem *item){
                @strongify(self)
                self.model.city = @"";
                self.model.province = item.title;
                [self.city setTitle:@"选择城市" forState:UIControlStateNormal];
                self.viewModel.city = [self.viewModel.cityData valueForKey:item.title];
                [self.province setTitle:title forState:UIControlStateNormal];
                [self loadCity];
            };
            [_provinceArray addObject:item];
        }
    }
    return _provinceArray;
}
-(void)loadCity {
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    for (NSString *title in self.viewModel.city) {
        MenuItem *item = [[MenuItem alloc] init];
        item.title = title;
        item.selectItemBlock = ^(MenuItem *item){
            self.model.city = item.title;
            [self.city setTitle:item.title forState:UIControlStateNormal];
        };
        [itemArray addObject:item];
    }
    self.cityArray = itemArray;
}

-(RegisterModel *)model{
    if (!_model) {
        _model = [[RegisterModel alloc] init];
    }
    return _model;
}
-(UIButton *)getCityButtonState{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.5f;
    button.layer.borderColor = RGB(231, 231, 231).CGColor;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.imageEdgeInsets = UIEdgeInsetsMake(12, 62, 12, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    return button;
}
-(UITextField *)creatTextfield{
    UITextField *field = [[UITextField alloc] init];
    field.font = [UIFont systemFontOfSize:14];
    field.backgroundColor = [UIColor whiteColor];
    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    field.leftView.userInteractionEnabled = NO;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"placeHoldtext" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    return field;
}
-(int)seconds{
    if (!_seconds) {
        _seconds = 0;
    }
    return _seconds;
}
@end
