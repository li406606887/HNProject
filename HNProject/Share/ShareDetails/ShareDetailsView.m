//
//  ShareDetailsView.m
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareDetailsView.h"
#import "ShareDetailsModel.h"
#import "ShareDetailsViewModel.h"
#import "SegmentControlView.h"
#import "ShareDetailsTableCell.h"
#import "ShareDetailsHeadView.h"
#import "CommentsView.h"
#import "RewardView.h"

@interface ShareDetailsView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) ShareDetailsViewModel *viewModel;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) ShareDetailsHeadView *detailsHeadView;
@property(nonatomic,strong) SegmentControlView *segmentView;
@property(nonatomic,assign) int oldIndex;
@end

@implementation ShareDetailsView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (ShareDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews {
    [self addSubview:self.table];
    if (self.viewModel.type!=2) {
        [self addSubview:self.segmentView];
    }
    [self.headView addSubview:self.detailsHeadView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    
    if (self.viewModel.type != 2) {
        [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.centerX.equalTo(self);
            make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 40));
        }];
        [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 40, 0));
        }];
    }else{
        [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    [self.detailsHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headView);
    }];
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.shareDetailsCommand execute:nil];
    [self.viewModel.getShareCommentsCommand execute:nil];
    
    [[self.viewModel.editorialCommentsSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        CommentsView *commentsView = [[CommentsView alloc] initWithViewModel:self.viewModel];
        [self addSubview:commentsView];
        [commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }];
    
    [[self.viewModel.rewardClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        RewardView* rewardView = [[RewardView alloc] initWithViewModel:self.viewModel];
        
        [self addSubview:rewardView];
        [rewardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }];
    

    [self.viewModel.refreshCellUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.table reloadData];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    }];
    
    [self.viewModel.refreshCellSubject subscribeNext:^(ShareCellDetailsModel*  _Nullable model) {
        @strongify(self)
        self.viewModel.shareDetailsCellArray[self.viewModel.oldIndex] = model;
        [self.table reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.shareDetailsCellArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareDetailsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ShareDetailsTableCell class])] forIndexPath:indexPath];
    cell.model = self.viewModel.shareDetailsCellArray[indexPath.row];
    cell.viewModel = self.viewModel;
    cell.tag = indexPath.row;
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
        _table.dataSource = self;
        _table.delegate = self;
        _table.tableHeaderView = self.headView;
        @weakify(self)
        _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.getShareCommentsCommand execute:nil];
        }];
        _table.separatorInset = UIEdgeInsetsMake(0, 50, 0, 10);
        [_table registerClass:[ShareDetailsTableCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ShareDetailsTableCell class])]];
    }
    return _table;
}

-(SegmentControlView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[SegmentControlView alloc] initWithViewModel:self.viewModel];
    }
    return _segmentView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH+120)];
    }
    return _headView;
}

-(ShareDetailsHeadView *)detailsHeadView{
    if (!_detailsHeadView) {
        _detailsHeadView = [[ShareDetailsHeadView alloc] initWithViewModel:self.viewModel];
    }
    return _detailsHeadView;
}

@end
