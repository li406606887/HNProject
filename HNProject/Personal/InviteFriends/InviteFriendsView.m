
//
//  InviteFriendsView.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "InviteFriendsView.h"
#import "InviteFriendsViewModel.h"
#import "InviteFriendsCell.h"

@interface InviteFriendsView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) InviteFriendsViewModel *viewModel;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIView *sectionView;
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UILabel *referencesName;
@property(nonatomic,strong) UILabel *qqNum;
@property(nonatomic,strong) UILabel *myInviteCode;
@property(nonatomic,strong) UIButton *sumbit;
@end

@implementation InviteFriendsView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (InviteFriendsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.headView];
    [self.headView addSubview:self.referencesName];
    [self.headView addSubview:self.qqNum];
    [self addSubview:self.table];
    [self addSubview:self.myInviteCode];
    [self addSubview:self.sumbit];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(20);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 81));
    }];
    [self.referencesName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headView).with.offset(-10);
        make.top.equalTo(self.headView);
        make.size.mas_offset(CGSizeMake(100, 40));
    }];
    [self.qqNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headView).with.offset(-10);
        make.bottom.equalTo(self.headView.mas_bottom);
        make.size.mas_offset(CGSizeMake(100, 40));
    }];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.headView.mas_bottom).with.offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, SCREEN_HEIGHT-280));
    }];
    [self.myInviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.table.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 25));
    }];
    [self.sumbit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.myInviteCode.mas_bottom).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 35));
    }];
    
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.getInviteFrendsCommand execute:nil];
    [self.viewModel.getInvitePeopleCommand execute:nil];
    [self.viewModel.refreshUISuject subscribeNext:^(NSString*  _Nullable type) {
        @strongify(self);
        if ([type intValue]==1) {
            self.qqNum.text = [NSString stringWithFormat:@"%@",self.viewModel.peopleModel.qq];
            self.referencesName.text = self.viewModel.peopleModel.name.length>0 ? [NSString stringWithFormat:@"%@",self.viewModel.peopleModel.name] : @"...";
        }else{
            [self.table reloadData];
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InviteFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([InviteFriendsCell class])] forIndexPath:indexPath];
    cell.model = self.viewModel.dataArray[indexPath.row];
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
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.layer.masksToBounds = YES;
        _table.layer.cornerRadius = 3;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_table registerClass:[InviteFriendsCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([InviteFriendsCell class])]];
    }
    return _table;
}

-(UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50, 60)];
        _sectionView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGB(126, 126, 126);
        [_sectionView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_sectionView);
            make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-80, 1));
        }];
        UILabel *sectionTitle = [[UILabel alloc] init];
        [sectionTitle setText:@"我邀请的好友列表"];
        [sectionTitle setTextAlignment:NSTextAlignmentCenter];
        [sectionTitle setBackgroundColor:[UIColor whiteColor]];
        [_sectionView addSubview:sectionTitle];
        [sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_sectionView);
            make.size.mas_offset(CGSizeMake(160, 20));
        }];
    }
    return _sectionView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 3;
        UILabel *myReferences = [[UILabel alloc] init];
        myReferences.text = @"  我的介绍人";
        myReferences.font = [UIFont systemFontOfSize:14];
        myReferences.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:myReferences];
        UILabel *referencesQQ = [[UILabel alloc] init];
        referencesQQ.text = @"  介绍人QQ";
        referencesQQ.font = [UIFont systemFontOfSize:14];
        referencesQQ.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:referencesQQ];
        
        [myReferences mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(_headView).with.offset(1);
            make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 40));
        }];
        [referencesQQ mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(myReferences.mas_bottom).with.offset(1);
            make.centerX.equalTo(_headView);
            make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-50, 40));
        }];
    }
    return _headView;
}
-(UILabel *)qqNum{
    if (!_qqNum) {
        _qqNum = [[UILabel alloc] init];
        _qqNum.text = @"...";
        _qqNum.font = [UIFont systemFontOfSize:14];
    }
    return _qqNum;
}
-(UILabel *)referencesName{
    if (!_referencesName) {
        _referencesName = [[UILabel alloc] init];
        _referencesName.text = @"...";
        _referencesName.font = [UIFont systemFontOfSize:14];
    }
    return _referencesName;
}
-(UILabel *)myInviteCode{
    if (!_myInviteCode) {
        _myInviteCode = [[UILabel alloc] init];
        
        NSDictionary *dic =@{NSFontAttributeName :[UIFont systemFontOfSize:24]};
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的邀请码 %@",[HNUesrInformation getInformation].model.invite_code] attributes:dic];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 5)];
        _myInviteCode.textAlignment = NSTextAlignmentCenter;
        _myInviteCode.attributedText = att;
    }
    return _myInviteCode;
}
-(UIButton *)sumbit{
    if (!_sumbit) {
        _sumbit = [UIButton buttonWithType:UIButtonTypeCustom];
        _sumbit.backgroundColor = DEFAULT_COLOR;
        [_sumbit setTitle:@"复制邀请码" forState:UIControlStateNormal];
        [_sumbit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sumbit.layer.masksToBounds = YES;
        _sumbit.layer.cornerRadius = 3;
        [[_sumbit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [HNUesrInformation getInformation].model.invite_code;
            showMassage(@"复制成功");
        }];
    }
    return _sumbit;
}
@end
