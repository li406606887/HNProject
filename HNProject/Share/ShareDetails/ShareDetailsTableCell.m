//
//  ShareDetailsTableCell.m
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareDetailsTableCell.h"

@interface ShareDetailsTableCell()
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UILabel *time;
@property(nonatomic,strong) UIButton *praise;
@end

@implementation ShareDetailsTableCell

-(void)setupViews{
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.praise];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).with.offset(10);
        make.centerY.equalTo(self.icon);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-100, 20));
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.mas_offset(-10);
        make.centerY.equalTo(self.icon);
        make.size.mas_offset(CGSizeMake(150, 20));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(50);
        make.top.equalTo(self.icon.mas_bottom).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 20));
    }];
    [self.praise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.top.equalTo(self.time.mas_bottom).with.offset(10);
        make.size.mas_offset(CGSizeMake(60, 20));
    }];
}

-(void)setModel:(ShareCellDetailsModel *)model {
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"Personal_Message_Icon"]];
    self.name.text = [NSString stringWithFormat:@"%@",model.user.taobao_id];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
    self.time.text = [NSString stringWithFormat:@"%@",model.created_at];
    NSString *comments = model.zan.length>0? model.zan : @"0" ;
    [self.praise setTitle:comments forState:UIControlStateNormal];
    NSString *commentsID = [NSString stringWithFormat:@"%@",model.ID];
    NSString *state = [[HNUesrInformation getInformation].praiseDic objectForKey:commentsID];
    if (state != nil) {
        self.praise.selected = YES;
    }else{
        self.praise.selected = NO;
    }
//    NSLog(@"%@",model.ID);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius =15;
        _icon.backgroundColor = RGB(210, 210, 210);
    }
    return _icon;
}

-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = RGB(40, 40, 40);
        _name.text = @"昵称";
        _name.font = [UIFont systemFontOfSize:14];
    }
    return _name;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = RGB(53, 53, 53);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
-(UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.text = @"00-00 00:00";
        _time.font = [UIFont systemFontOfSize:13];
        _time.textAlignment = NSTextAlignmentRight;
        _time.textColor = RGB(180, 180, 180);
    }
    return _time;
}
-(UIButton *)praise {
    if (!_praise) {
        _praise = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praise setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        [_praise.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_praise setImage:[UIImage imageNamed:@"Share_Icon_Praise_Normal"] forState:UIControlStateNormal];
        [_praise setImage:[UIImage imageNamed:@"Share_Icon_Praise_Selected"] forState:UIControlStateSelected];
        _praise.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        @weakify(self)
        [[_praise rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
            [param setObject:_model.ID forKey:@"comment_id"];
            if (self.praise.selected == YES) {
                [self.viewModel.commentsCancelPraiseCommand execute:param];
            }else {
                [self.viewModel.commentsPraiseCommand execute:param];
            }
            self.viewModel.oldIndex = (int)self.tag;
        }];
    }
    return _praise;
}
@end
