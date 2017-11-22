//
//  PersonalInfoView.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PersonalInfoView.h"
#import "PersonalInfoViewModel.h"
#import "PersonalInfoModel.h"
#import "PersonalInfoTableViewCell.h"

@interface PersonalInfoView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) PersonalInfoViewModel *viewModel;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *textArray;
@end

@implementation PersonalInfoView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (PersonalInfoViewModel *)viewModel;
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
-(void)bindViewModel {
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        HNUserModel *model = [HNUserModel mj_objectWithKeyValues:x];
        self.textArray[0] = model.avatar.length>0 ? model.avatar:@"";
        self.textArray[1] = model.taobao_id.length>0 ? model.taobao_id:@"";
        self.textArray[2] = model.real_name.length>0 ? model.real_name:@"";
        self.textArray[3] = model.phone.length>0 ? model.phone:@"";
        self.textArray[4] = model.qq.length>0 ? model.qq:@"";
        self.textArray[5] = [NSString stringWithFormat:@"%@-%@",model.province,model.city];
        self.textArray[6] = model.motto.length>0 ? model.motto:@"123123";
        [self.table reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath.row==0 ? 70:50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        PersonalInfoIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([PersonalInfoIconTableViewCell class])] forIndexPath:indexPath];
        cell.iconUrl = self.textArray[0];
        return cell;
    }else {
        PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([PersonalInfoTableViewCell class])]];
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.detailTextLabel.text = self.textArray[indexPath.row];
        if (indexPath.row==6) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel.cellClickSubject sendNext:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
}


-(UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.dataSource = self;
        _table.delegate = self;
        _table.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        [_table registerClass:[PersonalInfoTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([PersonalInfoTableViewCell class])]];
        [_table registerClass:[PersonalInfoIconTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([PersonalInfoIconTableViewCell class])]];
    }
    return _table;
}

-(NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"头像",@"昵称(淘宝账号)",@"真实姓名",@"手机号码",@"QQ号码",@"所在城市",@"个性签名", nil];
    }
    return _titleArray;
}

-(NSMutableArray *)textArray{
    if (!_textArray) {
        _textArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",nil];
    }
    return _textArray;
}
@end
