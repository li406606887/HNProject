//
//  PersonalView.m
//  JYQHProject
//
//  Created by user on 2017/7/7.
//  Copyright © 2017年 zero. All rights reserved.
//

#import "PersonalView.h"
#import "PersonalTableViewCell.h"
#import "PersonalHeadView.h"
#import "PersonalViewModel.h"

@interface PersonalView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)PersonalHeadView *personalView;
@property(nonatomic,strong)PersonalViewModel *viewModel;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *detailArray;

@end

@implementation PersonalView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (PersonalViewModel*)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.table];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    WS(weakSelf)
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.personalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.headView);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([PersonalTableViewCell class])]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.viewModel.personalCellClick sendNext:[NSString stringWithFormat:@"%ld",indexPath.row]];
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
        _table.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _table.tableHeaderView = self.headView;
        [_table registerClass:[PersonalTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([PersonalTableViewCell class])]];
        _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_table reloadData];
            [_table.mj_header endRefreshing];
        }];
    }
    return _table;
}
-(NSArray *)titleArray{
    if (!_titleArray) {
        if ([HNUesrInformation getInformation].hiddenStyle == NO) {
            _titleArray = [NSArray arrayWithObjects:@"历史分享",@"修改密码",@"分享生活",nil];
        }else{
            _titleArray = [NSArray arrayWithObjects:@"我的购买",@"我的金币",@"历史分享",@"邀请好友",@"修改密码",@"常见问题",nil];
        }
    }
    return _titleArray;
}


-(PersonalHeadView *)personalView{
    if (!_personalView) {
        _personalView = [[PersonalHeadView alloc] initWithViewModel:self.viewModel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        @weakify(self)
        [[tap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
         @strongify(self)
            [self.viewModel.personalCellClick sendNext:@"-1"];
        }];
        [_personalView addGestureRecognizer:tap];
    }
    return _personalView;
}
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        [_headView addSubview:self.personalView];
    }
    return _headView;
}
@end
