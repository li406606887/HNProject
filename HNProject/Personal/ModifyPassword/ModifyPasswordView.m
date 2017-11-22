//
//  ModifyPasswordView.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ModifyPasswordView.h"
#import "ModifyPasswordViewModel.h"

@interface ModifyPasswordView()
@property(nonatomic,strong) ModifyPasswordViewModel *viewModel;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UITextField *oldPwd;//旧密码
@property(nonatomic,strong) UITextField *nowPwdField;//现在的密码
@property(nonatomic,strong) UITextField *repeatNewPwd;//重复密码
@property(nonatomic,strong) UIButton *sumbit;
@end

@implementation ModifyPasswordView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (ModifyPasswordViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews {
    [self addSubview:self.backView];
    [self.backView addSubview:self.oldPwd];
    [self.backView addSubview:self.nowPwdField];
    [self.backView addSubview:self.repeatNewPwd];
    [self addSubview:self.sumbit];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 122));
    }];
    [self.oldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self.backView);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
    [self.nowPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.oldPwd.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
    [self.repeatNewPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.nowPwdField.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
    [self.sumbit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.backView.mas_bottom).with.offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 3;
    }
    return _backView;
}
-(UITextField *)oldPwd{
    if (!_oldPwd) {
        _oldPwd =  [self creatTextfield];
        _oldPwd.placeholder = @"请输入原密码";
    }
    return _oldPwd;
}

-(UITextField *)nowPwdField {
    if (!_nowPwdField) {
        _nowPwdField = [self creatTextfield];
        _nowPwdField.placeholder = @"请输入新密码";
    }
    return _nowPwdField;
}

-(UITextField *)repeatNewPwd{
    if (!_repeatNewPwd) {
        _repeatNewPwd = [self creatTextfield];
        _repeatNewPwd.placeholder = @"请重复新密码";
    }
    return _repeatNewPwd;
}

-(UITextField *)creatTextfield{
    UITextField *field = [[UITextField alloc] init];
    field.font = [UIFont systemFontOfSize:14];
    field.backgroundColor = [UIColor whiteColor];
    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
    field.leftView.userInteractionEnabled = NO;
    field.leftViewMode = UITextFieldViewModeAlways;
    return field;
}
-(UIButton *)sumbit{
    if (!_sumbit) {
        _sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sumbit setBackgroundColor:DEFAULT_COLOR];
        [_sumbit setTitle:@"保存密码" forState:UIControlStateNormal];
        [_sumbit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sumbit.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _sumbit.layer.masksToBounds = YES;
        _sumbit.layer.cornerRadius = 3;
        @weakify(self);
        [[_sumbit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (![self.nowPwdField.text isEqualToString:self.repeatNewPwd.text]) {
                showMassage(@"两次密码输入不一致");
                return ;
            }
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setObject:self.oldPwd.text forKey:@"old_password"];
            [data setObject:self.nowPwdField.text forKey:@"new_password"];
            [self.viewModel.modifyPwdCommand execute:data];
        }];
    }
    return _sumbit;
}
@end
