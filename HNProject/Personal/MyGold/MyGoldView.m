//
//  MyGoldView.m
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyGoldView.h"
#import "MyGoldViewModel.h"
#import "MyGoldTableCell.h"
#import "WithdrawalMyBankView.h"

@interface MyGoldView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) MyGoldViewModel *viewModel;
@property(nonatomic,strong) UIView *goldNumView;
@property(nonatomic,strong) UILabel *goldNum;
@property(nonatomic,strong) UIView *withdrawalNumView;
@property(nonatomic,strong) UITextField *withdrawalNum;
@property(nonatomic,strong) UILabel *canWithdrawNum;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIButton *sumbit;
@property(nonatomic,strong) WithdrawalMyBankView *bankView;
@end


@implementation MyGoldView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (MyGoldViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews{
    [self addSubview:self.goldNumView];
    [self addSubview:self.withdrawalNumView];
    [self addSubview:self.sumbit];
    [self addSubview:self.table];
    [self.goldNumView addSubview:self.goldNum];
    [self.withdrawalNumView addSubview:self.canWithdrawNum];
    [self.withdrawalNumView addSubview:self.withdrawalNum];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.goldNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 80));
    }];
    [self.goldNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.goldNumView);
        make.size.mas_offset(CGSizeMake(200, 80));
    }];
    [self.withdrawalNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.goldNumView.mas_bottom).with.offset(5);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 80));
    }];
    [self.canWithdrawNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.withdrawalNumView).with.offset(10);
        make.top.equalTo(self.withdrawalNumView).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 20));
    }];
    [self.withdrawalNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_withdrawalNumView);
        make.top.equalTo(self.canWithdrawNum.mas_bottom).with.offset(4);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-120, 23));
    }];
    [self.sumbit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.withdrawalNumView.mas_bottom);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 35));
    }];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.sumbit.mas_bottom).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-295));
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGoldTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([MyGoldTableCell class])] forIndexPath:indexPath];
    cell.model = self.viewModel.dataArray[indexPath.row];
    return cell;
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.myGoldCommand execute:nil];
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:25],NSForegroundColorAttributeName:[UIColor blackColor]};
        
        NSString *string = [NSString stringWithFormat:@"当前金币(个):\n%@",[HNUesrInformation getInformation].model.golds];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string attributes:dic];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 8)];
        [att addAttribute:NSForegroundColorAttributeName value:RGB(101, 101, 101) range:NSMakeRange(0, 8)];
        self.goldNum.attributedText = att;
        
        NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(155, 155, 155)};
        NSString *string2 = [NSString stringWithFormat:@"输入提现数量:(当前可提现%@个金币)",[HNUesrInformation getInformation].model.golds];
        NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:string2 attributes:dic2];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 7)];
        self.canWithdrawNum.attributedText = att1;
        [self.table reloadData];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_table registerClass:[MyGoldTableCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([MyGoldTableCell class])]];
    }
    return _table;
}
-(UIView *)goldNumView{
    if (!_goldNumView) {
        _goldNumView = [[UIView alloc] init];
        _goldNumView.backgroundColor = [UIColor whiteColor];
        _goldNumView.layer.masksToBounds = YES;
        _goldNumView.layer.cornerRadius = 3;
        
    }
    return _goldNumView;
}
-(UIView *)withdrawalNumView{
    if (!_withdrawalNumView) {
        _withdrawalNumView = [[UIView alloc] init];
        _withdrawalNumView.backgroundColor = [UIColor whiteColor];
        _withdrawalNumView.layer.masksToBounds = YES;
        _withdrawalNumView.layer.cornerRadius = 3;
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"Personal_Icon_Gold"];
        [_withdrawalNumView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_withdrawalNumView).with.offset(10);
            make.top.equalTo(_withdrawalNumView).with.offset(35);
            make.size.mas_offset(CGSizeMake(17, 23));
        }];
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:RGB(200, 200, 200)];
        [_withdrawalNumView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_withdrawalNumView);
            make.top.equalTo(icon.mas_bottom).with.offset(4);
            make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-70, 1));
        }];
    }
    return _withdrawalNumView;
}
-(UIButton *)sumbit{
    if (!_sumbit) {
        _sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
        _sumbit.backgroundColor = DEFAULT_COLOR;
        [_sumbit setTitle:@"申请提现" forState:UIControlStateNormal];
        [_sumbit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sumbit.layer.masksToBounds = YES;
        _sumbit.layer.cornerRadius = 3;
        @weakify(self)
        [[_sumbit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           @strongify(self)
            if (self.viewModel.cash.length<1) {
                showMassage(@"请输入您要提现的数量");
                return ;
            }
            if (self.viewModel.bankArray.count<1) {
                showMassage(@"暂无银行卡信息");
                return ;
            }
            [self addSubview:self.bankView];
            [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }];
    }
    return _sumbit;
}
-(UILabel *)goldNum{
    if (!_goldNum) {
        _goldNum = [[UILabel alloc] init];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:25],NSForegroundColorAttributeName:[UIColor blackColor]};
        
        NSString *string = [NSString stringWithFormat:@"当前金币(个):\n%@",[HNUesrInformation getInformation].model.golds];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string attributes:dic];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 8)];
        [att addAttribute:NSForegroundColorAttributeName value:RGB(101, 101, 101) range:NSMakeRange(0, 8)];
        _goldNum.attributedText = att;
        _goldNum.textAlignment = NSTextAlignmentCenter;
        _goldNum.numberOfLines = 0;
    }
    return _goldNum;
}

-(UILabel *)canWithdrawNum {
    if (!_canWithdrawNum) {
        _canWithdrawNum = [[UILabel alloc] init];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(155, 155, 155)};
        NSString *string = [NSString stringWithFormat:@"输入提现数量:(当前可提现%@个金币)",[HNUesrInformation getInformation].model.golds];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string attributes:dic];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 7)];
        _canWithdrawNum.attributedText = att;

    }
    return _canWithdrawNum;
}
-(UITextField *)withdrawalNum {
    if (!_withdrawalNum) {
        _withdrawalNum = [[UITextField alloc] init];
        _withdrawalNum.placeholder = @"";
        _withdrawalNum.font = [UIFont systemFontOfSize:20];
        _withdrawalNum.keyboardType = UIKeyboardTypeNumberPad;
        @weakify(self)
        [[_withdrawalNum rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
         @strongify(self)
            if ([x intValue]>[[HNUesrInformation getInformation].model.golds intValue]) {
                self.sumbit.userInteractionEnabled = NO;
                [self.sumbit setBackgroundColor:RGB(222, 222, 222)];
            }else{
                self.sumbit.userInteractionEnabled = YES;
                [self.sumbit setBackgroundColor:DEFAULT_COLOR];
            }
            self.viewModel.cash = x;
        }];
    }
    return _withdrawalNum;
}
-(WithdrawalMyBankView *)bankView{
    if (!_bankView) {
        _bankView = [[WithdrawalMyBankView alloc] initWithViewModel:self.viewModel];
    }
    return _bankView;
}
@end
