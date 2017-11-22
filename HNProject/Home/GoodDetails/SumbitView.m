//
//  SumbitView.m
//  HNProject
//
//  Created by user on 2017/7/27.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "SumbitView.h"
#import "GoodDetailsViewModel.h"
#import "GoodDetailsModel.h"

@interface SumbitView()
@property(nonatomic,strong) GoodDetailsViewModel *viewModel;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *sumbit;
@end

@implementation SumbitView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (GoodDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews {
    [self setBackgroundColor:RGB(40, 40, 40)];
    [self addSubview:self.titleLabel];
    [self addSubview:self.sumbit];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(15);
        make.size.mas_offset(CGSizeMake(200, 25));
    }];
    
    [self.sumbit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.width.offset(100);
    }];
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.refreshUISubject subscribeNext:^(GoodDetailsModel*  _Nullable model) {
        @strongify(self)
        NSString *num;
        if ([HNUesrInformation getInformation].hiddenStyle==NO) {
            num =[NSString stringWithFormat:@"获得:%@积分    合计:%@份",model.golds,model.number_of];
        }else {
            num =[NSString stringWithFormat:@"奖金:%@金币    合计:%@份",model.golds,model.number_of];
        }
        self.titleLabel.text = num;
    }];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"合计";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}
-(UIButton *)sumbit{
    if (!_sumbit) {
        _sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sumbit setTitle:@"申请购买" forState:UIControlStateNormal];
        [_sumbit setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        [_sumbit.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sumbit setBackgroundColor:DEFAULT_COLOR];
        @weakify(self)
        [[_sumbit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.isApplyProjectCommand execute:nil];
        }];
    }
    return _sumbit;
}
@end
