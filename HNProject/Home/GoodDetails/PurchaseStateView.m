//
//  PurchaseStateView.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PurchaseStateView.h"
#import "GoodDetailsViewModel.h"
#import "PurchaseStateCell.h"
#import "MyBuyModel.h"

@interface PurchaseStateView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) GoodDetailsViewModel *viewModel;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UIImageView *blackLine;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIButton *editBtn;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *textArray;
@property(nonatomic,strong) NSMutableArray *colorArray;
@end

@implementation PurchaseStateView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (GoodDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.blackLine];
    [self addSubview:self.title];
    [self addSubview:self.lineView];
    [self addSubview:self.table];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.blackLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).with.offset(6);
        make.size.mas_offset(CGSizeMake(3, 14));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.top.equalTo(self).with.offset(6);
        make.size.mas_offset(CGSizeMake(100, 15));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.title.mas_bottom).with.offset(5);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-40, 1));
    }];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
        make.width.offset(SCREEN_WIDTH-40);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.refreshUISubject subscribeNext:^(GoodDetailsModel*  _Nullable model) {
        //        @strongify(self)
        
    }];
    
    [self.viewModel.refreshStateUISubject subscribeNext:^(MyBuyModel *  _Nullable model) {
        @strongify(self)
        switch (self.viewModel.type) {
            case 1:
                self.titleArray = [NSMutableArray arrayWithObjects:@"购买编号:",@"申请时间:",@"订单状态:",nil];
                self.textArray = [NSMutableArray arrayWithObjects:
                                  [NSString stringWithFormat:@"%@",model.apply_number],
                                  [NSString stringWithFormat:@"%@",model.applied_at],@"申请已提交,待商家审核", nil];
                self.colorArray = [NSMutableArray arrayWithObjects:@"",@"",@"1", nil];
                break;
            case 2:
                self.titleArray = [NSMutableArray arrayWithObjects:@"购买编号:",@"申请时间:",@"审核时间:",@"订单状态:",nil];
                self.textArray = [NSMutableArray arrayWithObjects:
                                  [NSString stringWithFormat:@"%@",model.apply_number],
                                  [NSString stringWithFormat:@"%@",model.applied_at],
                                  [NSString stringWithFormat:@"%@",model.checked_at],@"申请已提交,待商家审核", nil];
                self.colorArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"1", nil];
                break;
            case 3:
                self.titleArray = [NSMutableArray arrayWithObjects:@"购买编号:",@"申请时间:",@"审核时间:",@"提交时间:",@"驳回时间:",@"驳回理由:",@"订单状态:",nil];
                self.textArray = [NSMutableArray arrayWithObjects:
                                  [NSString stringWithFormat:@"%@",model.apply_number],
                                  [NSString stringWithFormat:@"%@",model.applied_at],
                                  [NSString stringWithFormat:@"%@",model.checked_at],
                                  [NSString stringWithFormat:@"%@",model.submitted_at],
                                  [NSString stringWithFormat:@"%@",model.turned_at],
                                  [NSString stringWithFormat:@"%@",model.turned_reason]
                                  ,@"审核通过，待提交", nil];
                self.colorArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"1",@"",@"1", nil];
                break;
            case 4:
                if (model.turned_at.length<1||model.turned_reason.length<1||model.modified_at.length<1) {
                    self.titleArray = [NSMutableArray arrayWithObjects:@"购买编号:",@"申请时间:",@"审核时间:",@"提交时间:",@"订单状态:",nil];
                    self.textArray = [NSMutableArray arrayWithObjects:
                                      [NSString stringWithFormat:@"%@",model.apply_number],
                                      [NSString stringWithFormat:@"%@",model.applied_at],
                                      [NSString stringWithFormat:@"%@",model.checked_at],
                                      [NSString stringWithFormat:@"%@",model.submitted_at],
                                    
                                      @"审核不通过,待修改", nil];
                    self.colorArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"0",@"",@"1", nil];
                }else{
                    self.titleArray = [NSMutableArray arrayWithObjects:@"购买编号:",@"申请时间:",@"审核时间:",@"提交时间:",@"驳回时间:",@"驳回理由:",@"修改时间:",@"订单状态:",nil];
                    self.textArray = [NSMutableArray arrayWithObjects:
                                      [NSString stringWithFormat:@"%@",model.apply_number],
                                      [NSString stringWithFormat:@"%@",model.applied_at],
                                      [NSString stringWithFormat:@"%@",model.checked_at],
                                      [NSString stringWithFormat:@"%@",model.submitted_at],
                                      [NSString stringWithFormat:@"%@",model.turned_at],
                                      [NSString stringWithFormat:@"%@",model.turned_reason],
                                      [NSString stringWithFormat:@"%@",model.modified_at],
                                      @"待商家确认", nil];
                    self.colorArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"1",@"",@"1", nil];
                }
                break;
            case 5:
                self.titleArray = [NSMutableArray arrayWithObjects:@"购买编号:",@"申请时间:",@"审核时间:",@"提交时间:",@"驳回时间:",@"驳回理由:",@"修改时间:",@"审核时间:",@"订单状态:",nil];
                self.textArray = [NSMutableArray arrayWithObjects:
                                  [NSString stringWithFormat:@"%@",model.apply_number],
                                  [NSString stringWithFormat:@"%@",model.applied_at],
                                  [NSString stringWithFormat:@"%@",model.checked_at],
                                  [NSString stringWithFormat:@"%@",model.submitted_at],
                                  [NSString stringWithFormat:@"%@",model.turned_at],
                                  [NSString stringWithFormat:@"%@",model.turned_reason],
                                  [NSString stringWithFormat:@"%@",model.modified_at],
                                  [NSString stringWithFormat:@"%@",model.succeed_at],[NSString stringWithFormat:@"已审核通过,获得金币奖励%@个",model.project.golds], nil];
                self.colorArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"1",@"",@"",@"1", nil];
                break;
            default:
                break;
        }
        [self.table reloadData];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGFloat height = 20*self.titleArray.count;
    NSString *heightString ;
    if (_type==2||_type==3) {
        heightString = [NSString stringWithFormat:@"%f",height+87];
    }else{
        heightString = [NSString stringWithFormat:@"%f",height+47];
    }
    [self.viewModel.tableContentSizeSubject sendNext:heightString];
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PurchaseStateCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([PurchaseStateCell class])] forIndexPath:indexPath];
    cell.title.text = self.titleArray[indexPath.row];
    cell.instruction.text = [NSString stringWithFormat:@"%@",self.textArray[indexPath.row]];
    cell.instruction.textColor = [self.colorArray[indexPath.row] intValue] ==1? [UIColor redColor] : RGB(40, 40, 40);
    return cell;
}

-(void)setType:(int )type{
    _type = type;
    if (type == 2 || type == 3) {
        [self.table reloadData];
        self.table.tableFooterView = self.editBtn;
    }
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(UIImageView *)blackLine{
    if (!_blackLine) {
        _blackLine = [[UIImageView alloc] init];
        _blackLine.image = [UIImage imageNamed:@"Home_Good_Details_Black_Line"];
    }
    return _blackLine;
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"购买状态";
        _title.font = [UIFont systemFontOfSize:17];
    }
    return _title;
}
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(244, 244, 244);
    }
    return _lineView;
}
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor whiteColor];
        _table.bounces = NO;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_table registerClass:[PurchaseStateCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([PurchaseStateCell class])]];
    }
    return _table;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        [_editBtn setFrame:CGRectMake(0, 0, 100, 40)];
        [_editBtn setBackgroundColor:DEFAULT_COLOR];
        [_editBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_editBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _editBtn.layer.masksToBounds = YES;
        _editBtn.layer.cornerRadius = 3;
        @weakify(self)
        [[_editBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.sumbitPhotoSubject sendNext:self.viewModel.myBuyModel.ID];
        }];
    }
    return _editBtn ;
}


@end
