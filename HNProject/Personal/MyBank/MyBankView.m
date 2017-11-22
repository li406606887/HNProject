//
//  MyBankView.m
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBankView.h"
#import "MyBankViewModel.h"
#import "MyBankTableViewCell.h"
#import "MyBankFootView.h"

@interface MyBankView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) MyBankViewModel *viewModel;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIView *footView;
@property(nonatomic,strong) MyBankFootView *myBankFootView;
@end

@implementation MyBankView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (MyBankViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews{
    [self addSubview:self.table];
    [self.footView addSubview:self.myBankFootView];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.myBankFootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.footView);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 40));
    }];
}

-(void)bindViewModel {
    @weakify(self)
    [self.viewModel.refreshUISubject subscribeNext:^(NSString*  _Nullable x) {
        @strongify(self)
        [self.table reloadData];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.bankArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([MyBankTableViewCell class])] forIndexPath:indexPath];
    cell.model = self.viewModel.bankArray[indexPath.row];
    cell.viewModel = self.viewModel;
    return cell;
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
        _table.tableFooterView = self.footView;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_table registerClass:[MyBankTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([MyBankTableViewCell class])]];
    }
    return _table;
}
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    }
    return _footView;
}
-(MyBankFootView *)myBankFootView{
    if (!_myBankFootView) {
        _myBankFootView = [[MyBankFootView alloc] initWithViewModel:self.viewModel];
    }
    return _myBankFootView;
}
@end
