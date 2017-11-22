//
//  RewardView.m
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "RewardView.h"
#import "ShareDetailsViewModel.h"

@interface RewardView ()<UITextFieldDelegate>
@property(nonatomic,strong) ShareDetailsViewModel *viewModel;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,copy  ) NSString *str;
@property(nonatomic,strong) UILabel *prompt;
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UIImageView *iconImage;
@property(nonatomic,strong) UIImageView *closeImage;
@property(nonatomic,strong) UIView *fieldView;
@property(nonatomic,strong) UILabel *remainingMoney;
@property(nonatomic,strong) UIButton *sumbitBtn;
@end

@implementation RewardView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (ShareDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.backView];
    [self addSubview:self.fieldView];
    [self.fieldView addSubview:self.commentField];
    
    [self.fieldView addSubview:self.prompt];
    [self.fieldView addSubview:self.icon];
    [self.fieldView addSubview:self.line];
    [self.fieldView addSubview:self.remainingMoney];
    [self.fieldView addSubview:self.iconImage];
    [self addSubview:self.closeImage];
    [self addSubview:self.sumbitBtn];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.commentField becomeFirstResponder];
    });
    
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.sumbitBtn.mas_top);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 100));
    }];
    [self.prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.fieldView).with.offset(10);
        make.size.mas_offset(CGSizeMake(120, 20));
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fieldView).with.offset(13);
        make.top.equalTo(self.prompt.mas_bottom).with.offset(9);
        make.size.mas_offset(CGSizeMake(7, 12));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fieldView);
        make.top.equalTo(self.icon.mas_bottom).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 1));
    }];
    [self.remainingMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fieldView).with.offset(80);
        make.top.equalTo(self.line).with.offset(5);
        make.size.mas_offset(CGSizeMake(200, 20));
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.remainingMoney.mas_left).with.offset(-4);
        make.top.equalTo(self.line).with.offset(10);
        make.size.mas_offset(CGSizeMake(8, 10));
    }];
    [self.sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 40));
    }];
    [self.closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.fieldView.mas_top).with.offset(-23);
        make.size.mas_offset(CGSizeMake(23, 23));
    }];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(UITextField *)commentField{
    if (!_commentField) {
        _commentField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH-40, 20)];
        if ([HNUesrInformation getInformation].hiddenStyle==YES) {
            _commentField.placeholder = @"请输入打赏数额";
        }else{
            _commentField.placeholder = @"请输入打赏积分";
        }
        _commentField.font = [UIFont systemFontOfSize:14];
        _commentField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
        _commentField.leftView.userInteractionEnabled = NO;
        _commentField.leftViewMode = UITextFieldViewModeAlways;
        _commentField.keyboardType = UIKeyboardTypeNumberPad;
        @weakify(self)
        [_commentField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            if (_commentField.text.length<1) {
                self.sumbitBtn.userInteractionEnabled = NO;
                self.sumbitBtn.backgroundColor = RGB(200, 200, 200);
            }else{
                self.sumbitBtn.userInteractionEnabled = YES;
                self.sumbitBtn.backgroundColor = DEFAULT_COLOR;
            }
        }];
    }
    return _commentField;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.3;
    }
    return _backView;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        [_line setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _line;
}
-(UIView *)fieldView{
    if (!_fieldView) {
        _fieldView = [[UIView alloc] init];
        _fieldView.backgroundColor = [UIColor whiteColor];
    }
    return _fieldView;
}
-(UILabel *)prompt{
    if (!_prompt) {
        _prompt = [[UILabel alloc] init];
        _prompt.text = @"任意打赏";
        _prompt.font = [UIFont systemFontOfSize:14];
        _prompt.textColor = RGB(39, 39, 39);
    }
    return _prompt;
}
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        [_icon setImage:[UIImage imageNamed:@"Personal_Icon_Gold"]];
    }
    return _icon;
}
-(UILabel *)remainingMoney{
    if (!_remainingMoney) {
        _remainingMoney = [[UILabel alloc] init];
        if ([HNUesrInformation getInformation].hiddenStyle==YES) {
            _remainingMoney.text = [NSString stringWithFormat:@"金币余额:%@",[HNUesrInformation getInformation].model.golds];
        }else{
            _remainingMoney.text = [NSString stringWithFormat:@"剩余积分:%@",[HNUesrInformation getInformation].model.golds];
        }
        _remainingMoney.font = [UIFont systemFontOfSize:12];
        _remainingMoney.textColor = RGB(39, 39, 39);
        _remainingMoney.textAlignment = NSTextAlignmentLeft;
    }
    return _remainingMoney;
}
-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:@"Personal_Icon_Gold"];
    }
    return _iconImage;
}
-(UIButton *)sumbitBtn{
    if (!_sumbitBtn) {
        _sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sumbitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sumbitBtn setTitle:@"打赏" forState:UIControlStateNormal];
        [_sumbitBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sumbitBtn setBackgroundColor:DEFAULT_COLOR];
        @weakify(self)
        [[_sumbitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           @strongify(self)
            if (self.commentField.text.length<1) {
                if ([HNUesrInformation getInformation].hiddenStyle==YES) {
                    showMassage(@"请输入要打赏的金币")
                }else{
                    showMassage(@"请输入要打赏的积分")
                }
                return ;
            }
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
            [param setObject:self.commentField.text forKey:@"golds"];
            self.viewModel.rewardsCount = self.commentField.text;
            [self.viewModel.rewardClickCommand execute:param];
            [self removeFromSuperview];
        }];
    }
    return _sumbitBtn;
}
-(UIImageView *)closeImage{
    if (!_closeImage) {
        _closeImage = [[UIImageView alloc] init];
        _closeImage.image = [UIImage imageNamed:@"Personal_Icon_Close"];
        _closeImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        @weakify(self)
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
         @strongify(self)
            [self removeFromSuperview];
        }];
        [_closeImage addGestureRecognizer:tap];
    }
    return _closeImage;
}
@end
