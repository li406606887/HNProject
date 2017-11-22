
//
//  MyBankTableViewCell.m
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBankTableViewCell.h"
#import "MyBankModel.h"

@interface MyBankTableViewCell()
@property(nonatomic,strong) UILabel *bankName;
@property(nonatomic,strong) UILabel *bankCardNum;
@property(nonatomic,strong) UIButton *modifyBtn;
@property(nonatomic,strong) UIButton *deleteBtn;
@end

@implementation MyBankTableViewCell

-(void)setupViews{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.bankName];
    [self.contentView addSubview:self.bankCardNum];
    [self.contentView addSubview:self.modifyBtn];
    [self.contentView addSubview:self.deleteBtn];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    
    [self.bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);
        make.size.mas_offset(CGSizeMake(200, 30));
    }];
    
    [self.bankCardNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.bankName.mas_bottom);
        make.size.mas_offset(CGSizeMake(200, 40));
    }];
    
    [self.modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.bankCardNum.mas_bottom);
        make.size.mas_offset(CGSizeMake(80, 30));
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.bankCardNum.mas_bottom);
        make.size.mas_offset(CGSizeMake(80, 30));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setViewModel:(MyBankViewModel *)viewModel{
    _viewModel = viewModel;
}

-(void)setModel:(MyBankModel *)model {
    if (model) {
        _model = model;
        self.bankName.text = model.bank;
        self.bankCardNum.text = model.card_no;
    }
}

-(UIButton *)modifyBtn{
    if (!_modifyBtn) {
        _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_modifyBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_modifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_modifyBtn setImage:[UIImage imageNamed:@"Personal_Icon_ModifyBank"] forState:UIControlStateNormal];
        _modifyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        @weakify(self)
        [[_modifyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.bankEditSubject sendNext:self.model];
        }];
    }
    return _modifyBtn;
}
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"Personal_Icon_DeleteBank"] forState:UIControlStateNormal];
        _deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        @weakify(self)
        [[_deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.deleteBankCommand execute:self.model.ID];
        }];
    }
    return _deleteBtn;
}
-(UILabel *)bankName {
    if (!_bankName) {
        _bankName = [[UILabel alloc] init];
        _bankName.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        _bankName.textColor = RGB(40, 40, 40);
        
    }
    return _bankName;
}
-(UILabel *)bankCardNum{
    if (!_bankCardNum) {
        _bankCardNum = [[UILabel alloc] init];
        _bankCardNum.font = [UIFont systemFontOfSize:14];
        _bankCardNum.textColor = RGB(40, 40, 40);
    }
    return _bankCardNum;
}
@end
