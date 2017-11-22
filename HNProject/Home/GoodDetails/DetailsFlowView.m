//
//  DetailsFlowView.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "DetailsFlowView.h"
#import "GoodDetailsViewModel.h"

@interface DetailsFlowView()
@property(nonatomic,strong) GoodDetailsViewModel *viewModel;
@property(nonatomic,strong) UIView *followView;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UIImageView *blackLine;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UIButton *applyBuy;
@property(nonatomic,strong) UIButton *waitAudit;
@property(nonatomic,strong) UIButton *submitResults;
@property(nonatomic,strong) UIButton *complete;
@property(nonatomic,strong) UILabel *passwordFirst;
@property(nonatomic,strong) UILabel *passwordSecond;
@end

@implementation DetailsFlowView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (GoodDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.followView];
    [self addSubview:self.blackLine];
    [self addSubview:self.title];
    [self addSubview:self.lineView];
    [self addSubview:self.applyBuy];
    [self addSubview:self.waitAudit];
    [self addSubview:self.submitResults];
    [self addSubview:self.complete];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 90));
    }];
    [self.blackLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followView);
        make.top.equalTo(self.followView).with.offset(6);
        make.size.mas_offset(CGSizeMake(3, 14));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followView).with.offset(10);
        make.top.equalTo(self.followView).with.offset(6);
        make.size.mas_offset(CGSizeMake(100, 15));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.followView);
        make.top.equalTo(self.title.mas_bottom).with.offset(5);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-40, 1));
    }];
    [self.applyBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(5);
        make.left.equalTo(self.followView).with.offset((SCREEN_WIDTH-310)/5);
        make.size.mas_offset(CGSizeMake(70, 80));
    }];
    [self.waitAudit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(5);
        make.left.equalTo(self.applyBuy.mas_right).with.offset((SCREEN_WIDTH-310)/5);
        make.size.mas_offset(CGSizeMake(70, 80));
    }];
    [self.submitResults mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(5);
        make.left.equalTo(self.waitAudit.mas_right).with.offset((SCREEN_WIDTH-310)/5);
        make.size.mas_offset(CGSizeMake(70, 80));
    }];
    [self.complete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(5);
        make.left.equalTo(self.submitResults.mas_right).with.offset((SCREEN_WIDTH-310)/5);
        make.size.mas_offset(CGSizeMake(70, 80));
    }];
}

-(void)bindViewModel {
    @weakify(self)
    
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        int count = (int)self.viewModel.taoPwdArray.count;
        if (count == 2) {
            [self addSubview:self.passwordFirst];
            [self addSubview:self.passwordSecond];
            self.passwordFirst.text = self.viewModel.taoPwdArray[0];
            self.passwordSecond.text = self.viewModel.taoPwdArray[1];
            [self.passwordFirst mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.followView.mas_bottom).with.offset(10);
                make.centerX.equalTo(self);
                make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 30));
            }];
            [self.passwordSecond mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.passwordFirst.mas_bottom).with.offset(10);
                make.centerX.equalTo(self);
                make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 30));
            }];
        }else if(count==1){
            [self addSubview:self.passwordFirst];
            self.passwordFirst.text = self.viewModel.taoPwdArray[0];
            [self.passwordFirst mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.followView.mas_bottom).with.offset(10);
                make.centerX.equalTo(self);
                make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 30));
            }];
        }
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(UIImageView *)blackLine{
    if (!_blackLine) {
        _blackLine = [[UIImageView alloc] init];
        _blackLine.image = [UIImage imageNamed:@"Home_Good_Details_Black_Line"];
    }
    return _blackLine;
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"购买流程";
        _title.font = [UIFont systemFontOfSize:17];
    }
    return _title;
}
-(UIButton *)applyBuy{
    if (!_applyBuy) {
        _applyBuy = [self getButton];
        [_applyBuy setTitle:@"申请购买" forState:UIControlStateNormal];
        [_applyBuy setImage:[UIImage imageNamed:@"Home_Good_Details_Apply"] forState:UIControlStateNormal];
        
    }
    return _applyBuy;
}
-(UIButton *)waitAudit{
    if (!_waitAudit) {
        _waitAudit = [self getButton];
        [_waitAudit setTitle:@"等待审核" forState:UIControlStateNormal];
        [_waitAudit setImage:[UIImage imageNamed:@"Home_Good_Details_Wait_Audit"] forState:UIControlStateNormal];
    }
    return _waitAudit;
}
-(UIButton *)submitResults{
    if (!_submitResults) {
        _submitResults = [self getButton];
        [_submitResults setTitle:@"提交结果" forState:UIControlStateNormal];
        [_submitResults setImage:[UIImage imageNamed:@"Home_Good_Details_Sumbit"] forState:UIControlStateNormal];
        
    }
    return _submitResults;
}
-(UIButton *)complete{
    if (!_complete) {
        _complete = [self getButton];
        [_complete setTitle:@"购买完成" forState:UIControlStateNormal];
        [_complete setImage:[UIImage imageNamed:@"Home_Good_Details_Complete"] forState:UIControlStateNormal];
    }
    return _complete;
}
-(UIButton *)getButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 18, 45, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 0);
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:RGB(30, 30, 30) forState:UIControlStateNormal];
    
    return button;
}
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(244, 244, 244);
    }
    return _lineView;
}
-(UIView *)followView {
    if (!_followView) {
        _followView = [[UIView alloc] init];
        _followView.layer.masksToBounds = YES;
        _followView.layer.cornerRadius = 3;
        _followView.backgroundColor = [UIColor whiteColor];
    }
    return _followView;
}
-(UILabel *)passwordFirst {
    if (!_passwordFirst) {
        _passwordFirst = [[UILabel alloc] init];
        _passwordFirst.font = [UIFont systemFontOfSize:14];
        _passwordFirst.layer.masksToBounds = YES;
        _passwordFirst.layer.cornerRadius = 3;
        _passwordFirst.backgroundColor = [UIColor whiteColor];
        _passwordFirst.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _passwordFirst.text;
            showMassage(@"复制成功")
        }];
        [_passwordFirst addGestureRecognizer:tap];
    }
    return _passwordFirst;
}

-(UILabel *)passwordSecond {
    if (!_passwordSecond) {
        _passwordSecond = [[UILabel alloc] init];
        _passwordSecond.font = [UIFont systemFontOfSize:14];
        _passwordSecond.layer.masksToBounds = YES;
        _passwordSecond.layer.cornerRadius = 3;
        _passwordSecond.backgroundColor = [UIColor whiteColor];
        _passwordSecond.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _passwordSecond.text;
            showMassage(@"复制成功")
        }];
        [_passwordSecond addGestureRecognizer:tap];
    }
    return _passwordSecond;
}

@end
