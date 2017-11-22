//
//  EditBankView.m
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "EditBankView.h"
#import "MyBankModel.h"
#import "EditBankViewModel.h"
#import "EditBankModel.h"

@interface EditBankView()
@property(nonatomic,strong) EditBankViewModel *viewModel;
@property(nonatomic,strong) UIButton *arrowBtn;
@property(nonatomic,strong) UIButton *sumbit;
@property(nonatomic,strong) UILabel *cardholderLabel;
@property(nonatomic,strong) UILabel *cardNumLabel;
@property(nonatomic,strong) UILabel *promptLabel;
@property(nonatomic,strong) UITextField *cardholderField;
@property(nonatomic,strong) UITextField *cardNumField;
@property(nonatomic,strong) UILabel *bankCardLabel;
@property(nonatomic,strong) NSMutableArray *bankArray;
@property(nonatomic,strong) EditBankModel *editModel;
@end

@implementation EditBankView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (EditBankViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.cardholderLabel];
    [self addSubview:self.cardholderField];
    [self addSubview:self.cardNumLabel];
    [self addSubview:self.cardNumField];
    [self addSubview:self.bankCardLabel];
    [self addSubview:self.arrowBtn];
    [self addSubview:self.promptLabel];
    [self addSubview:self.sumbit];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.cardholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 40));
    }];
    [self.cardholderField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardholderLabel);
        make.right.equalTo(self.cardholderLabel.mas_right).with.offset(-8);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-106, 40));
    }];
    [self.cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.cardholderLabel.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 40));
    }];
    
    [self.cardNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardNumLabel);
        make.right.equalTo(self.cardNumLabel.mas_right).with.offset(-8);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-106, 40));
    }];
    
    [self.bankCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.cardNumLabel.mas_bottom).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 40));
    }];
    
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankCardLabel);
        make.right.equalTo(self.bankCardLabel.mas_right).with.offset(-8);
        make.size.mas_offset(CGSizeMake(30, 40));
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(25);
        make.top.equalTo(self.bankCardLabel.mas_bottom).with.offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 20));
    }];
    [self.sumbit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.promptLabel.mas_bottom).with.offset(5);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 40));
    }];
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.updateDataSubject subscribeNext:^(MyBankModel*  _Nullable model) {
        @strongify(self)
        self.cardNumField.text = model.card_no;
        self.bankCardLabel.text = model.bank;
        self.cardholderField.text = model.cardholder;
        self.editModel.card_no = model.card_no;
        self.editModel.bank = model.bank;
        self.editModel.cardholder = model.cardholder;
        self.viewModel.cardID = model.ID;
    }];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(UILabel *)cardholderLabel{
    if (!_cardholderLabel) {
        _cardholderLabel = [[UILabel alloc] init];
        _cardholderLabel.text = @"  持卡人";
        _cardholderLabel.font = [UIFont systemFontOfSize:14];
        _cardholderLabel.backgroundColor = [UIColor whiteColor];
        _cardholderLabel.layer.masksToBounds = YES;
        _cardholderLabel.layer.cornerRadius = 2;
    }
    return _cardholderLabel;
}
-(UITextField *)cardholderField{
    if (!_cardholderField) {
        _cardholderField = [[UITextField alloc] init];
        _cardholderField.font = [UIFont systemFontOfSize:14];
        _cardholderField.textAlignment = NSTextAlignmentRight;
        @weakify(self)
        [[_cardholderField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.editModel.cardholder = x;
        }];
    }
    return _cardholderField;
}
-(UILabel *)cardNumLabel{
    if (!_cardNumLabel) {
        _cardNumLabel = [[UILabel alloc] init];
        _cardNumLabel.text = @"  卡号";
        _cardNumLabel.font = [UIFont systemFontOfSize:14];
        _cardNumLabel.backgroundColor = [UIColor whiteColor];
        _cardNumLabel.layer.masksToBounds = YES;
        _cardNumLabel.layer.cornerRadius = 2;
    }
    return _cardNumLabel;
}
-(UITextField *)cardNumField{
    if (!_cardNumField) {
        _cardNumField = [[UITextField alloc] init];
        _cardNumField.font = [UIFont systemFontOfSize:14];
        _cardNumField.textAlignment = NSTextAlignmentRight;
        @weakify(self)
        [[_cardNumField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.editModel.card_no = x;
        }];
    }
    return _cardNumField;
}
-(UILabel *)bankCardLabel{
    if (!_bankCardLabel) {
        _bankCardLabel = [[UILabel alloc] init];
        _bankCardLabel.text = @"  选择银行卡";
        _bankCardLabel.textColor = RGB(160, 160, 160);
        _bankCardLabel.font = [UIFont systemFontOfSize:14];
        _bankCardLabel.backgroundColor = [UIColor whiteColor];
        _bankCardLabel.textAlignment = NSTextAlignmentCenter;
        _bankCardLabel.layer.masksToBounds = YES;
        _bankCardLabel.layer.cornerRadius = 2;
    }
    return _bankCardLabel;
}
-(UIButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBtn setImage:[UIImage imageNamed:@"Personal_Icon_EditBank_Arrow"] forState:UIControlStateNormal];
        @weakify(self)
        [[_arrowBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [PopoverView showPopoverViewAtPoint:CGPointZero withWidth:280 withMenuItems:self.bankArray];
        }];
    }
    return _arrowBtn;
}
-(UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = @"请认真核对信息后点击保存";
        _promptLabel.font = [UIFont systemFontOfSize:13];
    }
    return _promptLabel;
}
-(UIButton *)sumbit {
    if (!_sumbit) {
        _sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
        _sumbit.backgroundColor = DEFAULT_COLOR;
        [_sumbit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sumbit setTitle:@"保存" forState:UIControlStateNormal];
        _sumbit.layer.masksToBounds = YES;
        _sumbit.layer.cornerRadius = 2;
        [[_sumbit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.editModel.card_no.length<1 ) {
                showMassage(@"请填写银行卡号");
                return ;
            }else if (self.editModel.bank.length<1 ) {
                showMassage(@"请选择银行");
                return ;
            }else if (self.editModel.cardholder.length<1 ) {
                showMassage(@"请填写持卡人");
                return ;
            }
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:self.editModel.cardholder forKey:@"cardholder"];
            [param setObject:self.editModel.bank forKey:@"bank"];
            [param setObject:self.editModel.card_no forKey:@"card_no"];
            if (self.typer==1) {
                [self.viewModel.updateBankInfoCommand execute:param];
            }else{
                [self.viewModel.addBankInfoCommand execute:param];
            }
        }];
    }
    return _sumbit;
}
-(NSMutableArray *)bankArray {
    if (!_bankArray) {
        _bankArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<self.viewModel.bankArray.count; i++) {
            MenuItem *item = [[MenuItem alloc] init];
            item.title = self.viewModel.bankArray[i];
            item.index = i;
            @weakify(self)
            item.selectItemBlock = ^(MenuItem *item){
                @strongify(self)
                self.bankCardLabel.text = [NSString stringWithFormat:@"%@",item.title];
                self.editModel.bank = item.title;
            };
            [self.bankArray addObject:item];
        }
    }
    return _bankArray;
}
-(EditBankModel *)editModel{
    if (!_editModel) {
        _editModel = [[EditBankModel alloc] init];
    }
    return _editModel;
}
@end
