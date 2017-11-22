//
//  MyBankFootView.m
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBankFootView.h"
#import "MyBankViewModel.h"

@interface MyBankFootView ()
@property(nonatomic,strong) MyBankViewModel *viewModel;
@property(nonatomic,strong) UIView *addView;
@end

@implementation MyBankFootView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (MyBankViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews {
    [self addSubview:self.addView];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 40));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView *)addView{
    if (!_addView) {
        _addView = [[UIView alloc] init];
        [_addView setBackgroundColor:[UIColor whiteColor]];
        UILabel *title = [[UILabel alloc] init];
        [title setText:@"+添加银行卡"];
        [title setFont:[UIFont systemFontOfSize:13]];
        [_addView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_addView).with.offset(10);
            make.centerY.equalTo(_addView);
            make.size.mas_offset(CGSizeMake(200, 20));
        }];
        UIImageView *arrow = [[UIImageView alloc] init];
        [arrow setImage:[UIImage imageNamed:@"Personal_Icon_GrayArrow"]];
        [_addView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_addView);
            make.right.equalTo(_addView.mas_right).with.offset(-10);
            make.size.mas_offset(CGSizeMake(6, 13));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        @weakify(self)
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self)
            [self.viewModel.addBankCardClickSubject sendNext:nil];
        }];
        [_addView addGestureRecognizer:tap];
    }
    return _addView;
}
@end
