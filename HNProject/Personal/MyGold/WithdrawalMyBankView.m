//
//  WithdrawalMyBankView.m
//  HNProject
//
//  Created by user on 2017/7/28.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "WithdrawalMyBankView.h"
#import "MyGoldViewModel.h"
#import "MyBankModel.h"
#import "PopoverView.h"

@interface WithdrawalMyBankView()
@property(nonatomic,strong) MyGoldViewModel *viewModel;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIButton *chooseBank;
@property(nonatomic,strong) UILabel *bankName;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UIButton *cancel;
@property(nonatomic,strong) UIButton *sure;
@property(nonatomic,strong) NSMutableArray *itemArray;
@end

@implementation WithdrawalMyBankView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (MyGoldViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [self addSubview:self.backView];
    [self.backView addSubview:self.bankName];
    [self.backView addSubview:self.chooseBank];
    [self.backView addSubview:self.title];
    [self.backView addSubview:self.cancel];
    [self.backView addSubview:self.sure];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_offset(CGSizeMake(250, 130));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView);
        make.centerX.equalTo(self.backView);
        make.size.mas_offset(CGSizeMake(200, 30));
    }];
    [self.bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.left.equalTo(self.backView).with.offset(10);
        make.size.mas_offset(CGSizeMake(180, 30));
    }];
    
    [self.chooseBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).with.offset(-10);
        make.centerY.equalTo(self.backView);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    [self.cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.size.mas_offset(CGSizeMake(125, 30));
    }];
    [self.sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.size.mas_offset(CGSizeMake(125, 30));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 3;
    }
    return _backView;
}

-(UILabel *)bankName{
    if (!_bankName) {
        _bankName = [[UILabel alloc] init];
        _bankName.font = [UIFont systemFontOfSize:14];
        _bankName.textColor = RGB(40, 40, 40);
        MyBankModel *model = self.viewModel.bankArray[0];
        _bankName.text = [NSString stringWithFormat:@"%@-%@",model.bank,model.card_no];
        self.viewModel.bankId = model.ID;
    }
    return _bankName;
}
-(UIButton *)chooseBank {
    if (!_chooseBank) {
        _chooseBank = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBank setImage:[UIImage imageNamed:@"Personal_Icon_EditBank_Arrow"] forState:UIControlStateNormal];
        @weakify(self)
        [[_chooseBank rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [PopoverView showPopoverViewAtPoint:CGPointZero withWidth:280 withMenuItems:self.itemArray];
        }];
    }
    return _chooseBank;
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        _title.text = @"是否提现到当前卡号";
        _title.textColor = RGB(40, 40, 40);
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}
-(UIButton *)cancel{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        [_cancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cancel setBackgroundColor:DEFAULT_BG_COLOR];
        @weakify(self)
        [[_cancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self)
            [self removeFromSuperview];
        }];
    }
    return _cancel;
}
-(UIButton *)sure{
    if (!_sure) {
        _sure = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sure setTitle:@"确定" forState:UIControlStateNormal];
        [_sure setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        [_sure.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sure setBackgroundColor:DEFAULT_COLOR];
        @weakify(self)
        [[_sure rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
            [param setObject:self.viewModel.bankId forKey:@"card_id"];
            [param setObject:self.viewModel.cash forKey:@"golds"];
            [self.viewModel.withdrawalCommand execute:param];
            [self removeFromSuperview];
        }];
    }
    return _sure;
}
-(NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
        int i = 0;
        for (MyBankModel *model in self.viewModel.bankArray) {
            MenuItem *item = [[MenuItem alloc] init];
            item.title = [NSString stringWithFormat:@"%@-%@",model.bank,model.card_no];
            item.index = [model.ID intValue];
            @weakify(self)
            item.selectItemBlock = ^(MenuItem *item){
             @strongify(self)
                self.bankName.text = item.title;
                self.viewModel.bankId = [NSString stringWithFormat:@"%d",item.index];
            };
            i++;
            [_itemArray addObject:item];
        }
    }
    return _itemArray;
}
@end
