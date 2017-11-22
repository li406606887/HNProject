//
//  PendingModifyView.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PendingModifyView.h"
#import "MyBuyViewModel.h"
#import "MyBuyTableViewCell.h"


@interface PendingModifyView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) MyBuyViewModel *viewModel;
@property(nonatomic,strong) UITableView *table;
@end

@implementation PendingModifyView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (MyBuyViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.table];
    
    [self setNeedsUpdateConstraints];
    [self setNeedsUpdateConstraints];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.modifyDataCommand execute:nil];
    [self.viewModel.modifyRefreshUISubject subscribeNext:^(id  _Nullable x) {
     @strongify(self)
        [self.table reloadData];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",self.viewModel.modifyArray.count);
    return self.viewModel.modifyArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([MyBuyTableViewCell class])] forIndexPath:indexPath];
    cell.stateString = [NSString stringWithFormat:@"审核不通过,待修改"];
    [cell.operationButton setTitle:@"修改" forState:UIControlStateNormal];
    cell.model = self.viewModel.modifyArray[indexPath.row];
    cell.viewModel = self.viewModel;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBuyModel *model = self.viewModel.modifyArray[indexPath.row];
    [self.viewModel.modifyCellClickSubJect sendNext:model];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        @weakify(self)
        _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.modifyDataCommand execute:@"0"];
        }];
        _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.modifyDataCommand execute:nil];
        }];
        [_table registerClass:[MyBuyTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([MyBuyTableViewCell class])]];
    }
    return _table;
}
@end
