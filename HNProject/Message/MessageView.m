//
//  MessageView.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MessageView.h"
#import "MessageTableViewCell.h"
#import "MessageViewModel.h"

@interface MessageView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) MessageViewModel *viewModel;
@property(nonatomic,strong) UITableView *table;
@end

@implementation MessageView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (MessageViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews {
    [self addSubview:self.table];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(void)bindViewModel {
    @weakify(self)
    [self.viewModel.getMessageCommand execute:nil];
    [self.viewModel.successfulSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.table reloadData];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([MessageTableViewCell class])]];
    cell.model = self.viewModel.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = self.viewModel.dataArray[indexPath.row];
    [self.viewModel.cellClickSubject sendNext:model];
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
        _table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        @weakify(self)
        _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.getMessageCommand execute:@"0"];
        }];
        _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.getMessageCommand execute:nil];
        }];
        [_table registerClass:[MessageTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([MessageTableViewCell class])]];
    }
    return _table;
}
@end
