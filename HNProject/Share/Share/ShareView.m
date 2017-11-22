//
//  ShareView.m
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareView.h"
#import "ShareViewModel.h"
#import "ShareTableViewCell.h"

@interface ShareView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) ShareViewModel *viewModel;
@property(nonatomic,strong) UITableView *table;
@end

@implementation ShareView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (ShareViewModel *)viewModel;
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
    @weakify(self)
    [self.viewModel.shareDataCommand execute:nil];
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.table reloadData];
        switch ([x integerValue]) {
            case HeaderRefresh_HasMoreData:
                [self.table.mj_header endRefreshing];
                break;
            case HeaderRefresh_HasNoMoreData:
                [self.table.mj_header endRefreshing];
                self.table.mj_footer = nil;
                break;
                
            case FooterRefresh_HasMoreData:
                [self.table.mj_header endRefreshing];
                [self.table.mj_footer resetNoMoreData];
                [self.table.mj_footer endRefreshing];
                break;
                
            case FooterRefresh_HasNoMoreData:
                [self.table.mj_header endRefreshing];
                [self.table.mj_footer endRefreshingWithNoMoreData];
                break;
                
            case RefreshError:
                [self.table.mj_footer endRefreshing];
                [self.table.mj_header endRefreshing];
                break;
                
            default:
                break;
        }

    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.shareDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = SCREEN_WIDTH+125+[self.viewModel.textHeightArray[indexPath.row] floatValue];
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ShareTableViewCell class])]];
    cell.height = [self.viewModel.textHeightArray[indexPath.row] floatValue];
    cell.model = self.viewModel.shareDataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel.cellClickSubject sendNext:self.viewModel.shareDataArray[indexPath.row]];
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
        @weakify(self)
        _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.shareDataCommand execute:@"0"];
        }];
        _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.shareDataCommand execute:nil];
        }];
        [_table registerClass:[ShareTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ShareTableViewCell class])]];
    }
    return _table;
}
@end
