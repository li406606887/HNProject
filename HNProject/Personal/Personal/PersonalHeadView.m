//
//  PersonalHeadView.m
//  JYQHProject
//
//  Created by user on 2017/7/7.
//  Copyright © 2017年 zero. All rights reserved.
//

#import "PersonalHeadView.h"
#import "PersonalViewModel.h"

@interface PersonalHeadView()
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UILabel *nameTitle;
@property(nonatomic,strong)UIImageView *arrow;
@property(nonatomic,strong)PersonalViewModel *viewModel;
@end

@implementation PersonalHeadView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel {
    self.viewModel = (PersonalViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews {
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.icon];
    [self.backgroundView addSubview:self.nameTitle];
    [self.backgroundView addSubview:self.arrow];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    [super updateConstraints];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 100));
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.centerY.equalTo(self);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
    [self.nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).with.offset(10);
        make.centerY.equalTo(self.icon);
        make.size.mas_offset(CGSizeMake(200, 60));
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.size.mas_offset(CGSizeMake(8, 14));
    }];
    
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.personalDataUpdateClick subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        self.nameTitle.text = [HNUesrInformation getInformation].model.taobao_id !=nil ?[HNUesrInformation getInformation].model.taobao_id:[HNUesrInformation getInformation].model.phone;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:[HNUesrInformation getInformation].model.avatar] placeholderImage:[UIImage imageNamed:@"Personal_Message_Icon"]];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 30;
        _icon.backgroundColor = RGB(210, 210, 210);
        [_icon sd_setImageWithURL:[NSURL URLWithString:[HNUesrInformation getInformation].model.avatar] placeholderImage:[UIImage imageNamed:@"Personal_Message_Icon"]];
    }
    return _icon;
}
-(UILabel *)nameTitle {
    if (!_nameTitle) {
        _nameTitle = [[UILabel alloc] init];
        _nameTitle.font = [UIFont systemFontOfSize:14];
        _nameTitle.text = [HNUesrInformation getInformation].model.taobao_id !=nil ?[HNUesrInformation getInformation].model.taobao_id:[HNUesrInformation getInformation].model.phone;
    }
    return _nameTitle;
}
-(UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        _arrow.image = [UIImage imageNamed:@"Personal_Icon_GrayArrow"];
    }
    return _arrow;
}
-(UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

@end
