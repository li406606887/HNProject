//
//  CommonProblemsView.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "CommonProblemsView.h"
#import "CommonProblemsViewModel.h"
#import "CommonProblemsCell.h"

@interface CommonProblemsView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) CommonProblemsViewModel *viewModel;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIView *headView;
@end

@implementation CommonProblemsView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (CommonProblemsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
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

-(void)bindViewModel{
    [self.viewModel.getQuestionDataCommand execute:nil];
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        [self.table reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72+[self.viewModel.textHeightArray[indexPath.row] floatValue];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonProblemsCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([CommonProblemsCell class])] forIndexPath:indexPath];
    cell.model = self.viewModel.dataArray[indexPath.row];
    cell.height = [self.viewModel.textHeightArray[indexPath.row] floatValue];
    return cell;;
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
        _table.tableHeaderView = self.headView;
        [_table registerClass:[CommonProblemsCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([CommonProblemsCell class])]];
    }
    return _table;
}

-(UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        UILabel *prompt = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 20)];
        prompt.text = @"如有问题请咨询以下联系方式";
        prompt.font = [UIFont systemFontOfSize:13];
        [_headView addSubview:prompt];
        UIButton *telPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        [telPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [telPhone setTitle:@"13799268211" forState:UIControlStateNormal];
        [telPhone setImage:[UIImage imageNamed:@"Personal_Icon_Question_Tel_phone"] forState:UIControlStateNormal];
        [telPhone setFrame:CGRectMake(15, getTop(prompt), 105, 30)];
        [telPhone.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_headView addSubview:telPhone];
        
        UIButton *qq = [UIButton buttonWithType:UIButtonTypeCustom];
        [qq setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [qq setTitle:@"253545516" forState:UIControlStateNormal];
        [qq setImage:[UIImage imageNamed:@"Personal_Icon_Question_QQ_logo"] forState:UIControlStateNormal];
        [qq.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [qq setFrame:CGRectMake(15, getTop(telPhone)+5, 95, 30)];
        [_headView addSubview:qq];
        
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [callBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [callBtn setImage:[UIImage imageNamed:@"Personal_Icon_Question_Call"] forState:UIControlStateNormal];
        [callBtn setFrame:CGRectMake(getLeft(telPhone), getTop(prompt), 80, 30)];
        [_headView addSubview:callBtn];
        [[callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:13799268211"]];
        }];
    }
    return _headView;
}
@end
