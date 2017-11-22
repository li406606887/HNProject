
//
//  MessageTableViewCell.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell()
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *details;
@end

@implementation MessageTableViewCell

-(void)setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.details];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).with.offset(8);
        make.top.equalTo(self.contentView).with.offset(14);
        make.size.mas_offset(CGSizeMake(200, 20));
    }];
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.left.equalTo(self.icon.mas_right).with.offset(8);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-78, 35));
    }];
}

-(void)setModel:(MessageModel *)model{
    self.title.text = model.title;
    self.details.text = model.content;
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
        _icon.image = [UIImage imageNamed:@"Personal_Message_Icon"];
    }
    return _icon;
}
-(UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"系统消息";
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = RGB(31, 31, 31);
    }
    return _title;
}
-(UILabel *)details {
    if (!_details) {
        _details = [[UILabel alloc] init];
        _details.text = @"您申请的购买已经通过,请前往我的购买查看";
        _details.textColor = RGB(151, 151, 151);
        _details.numberOfLines = 2;
        _details.font =[UIFont systemFontOfSize:13];
    }
    return _details;
}
@end
