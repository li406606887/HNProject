//
//  ShareTableViewCell.m
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareTableViewCell.h"

@interface ShareTableViewCell ()
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *centerText;
@property(nonatomic,strong) UIImageView *scrollImage;
@property(nonatomic,strong) UILabel *time;
@property(nonatomic,strong) UIButton *like;
@property(nonatomic,strong) UIButton *comments;
@end

@implementation ShareTableViewCell
-(void)setupViews{
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.centerText];
    [self.contentView addSubview:self.scrollImage];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.like];
    [self.contentView addSubview:self.comments];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12);
        make.top.equalTo(self.contentView).with.offset(10);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).with.offset(12);
        make.centerY.equalTo(self.icon);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-100, 20));
    }];
    [self.centerText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.icon.mas_bottom).with.offset(10);
        make.width.offset(SCREEN_WIDTH-20);
    }];
    [self.scrollImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.like.mas_top);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-20, SCREEN_WIDTH-20));
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.centerY.equalTo(self.like).with.offset(-8);
        make.size.mas_offset(CGSizeMake(140, 20));
    }];
    [self.like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
        make.size.mas_offset(CGSizeMake(35, 45));
    }];
    [self.comments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.like.mas_left).with.offset(-10);
        make.centerY.equalTo(self.like);
        make.size.mas_offset(CGSizeMake(35, 45));
    }];
    
}

-(void)setModel:(ShareModel *)model{
    if (model) {
        _model = model;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:_model.user.avatar] placeholderImage:[UIImage imageNamed:@"Personal_Message_Icon"]];
        [self.name setText:_model.user.taobao_id];
        [self.time setText:_model.created_at];
        [self.centerText setText:_model.title];
        [self.scrollImage sd_setImageWithURL:[NSURL URLWithString:_model.thumb[0]] placeholderImage:[UIImage imageNamed:@""]];
        self.like.selected = YES;
        NSString *zanCount = model.zan.length < 1 ? @"0" : model.zan;
        [self.like setTitle:zanCount forState:UIControlStateNormal];
        NSString *commentsCount = model.comments.length < 1 ? @"0" : model.comments;
        [self.comments setTitle:commentsCount forState:UIControlStateNormal];
    }
}
-(void)setHeight:(CGFloat)height{
    if (height) {
        [self.centerText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height+5);
        }];
    }
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
        _icon.layer.cornerRadius = 25;
        _icon.backgroundColor = RGB(210, 210, 210);
        _icon.image = [UIImage imageNamed:@"Personal_Message_Icon"];
    }
    return _icon;
}

-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.text = @"...";
        _name.font = [UIFont systemFontOfSize:14];
        _name.textColor = RGB(14, 14, 14);
    }
    return _name;
}

-(UILabel *)centerText{
    if (!_centerText) {
        _centerText = [[UILabel alloc] init];
        _centerText.text = @"...";
        _centerText.font = [UIFont systemFontOfSize:14];
        _centerText.textColor = RGB(14, 14, 14);
        _centerText.numberOfLines = 0;
    }
    return _centerText;
}
-(UIImageView *)scrollImage {
    if (!_scrollImage) {
        _scrollImage = [[UIImageView alloc] init];
        [_scrollImage setBackgroundColor:[UIColor whiteColor]];
        _scrollImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _scrollImage;
}
-(UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.text = @"00-00";
        _time.font = [UIFont systemFontOfSize:13];
        _time.textColor = RGB(160, 160, 160);
    }
    return _time;
}
-(UIButton *)like{
    if (!_like) {
        _like = [UIButton buttonWithType:UIButtonTypeCustom];
        [_like setImage:[UIImage imageNamed:@"Share_Icon_Praise_Normal"] forState:UIControlStateNormal];
        [_like setImage:[UIImage imageNamed:@"Share_Icon_Praise_Selected"] forState:UIControlStateSelected];
        [_like.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_like setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        _like.titleEdgeInsets = UIEdgeInsetsMake(33, -30, 0, 0);
        _like.imageEdgeInsets = UIEdgeInsetsMake(-15, 0, 0, 0);
        _like.userInteractionEnabled = NO;
    }
    return _like;
}
-(UIButton *)comments {
    if (!_comments) {
        _comments = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comments setImage:[UIImage imageNamed:@"Share_Icon_Comments"] forState:UIControlStateNormal];
        [_comments.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_comments setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        _comments.titleEdgeInsets = UIEdgeInsetsMake(33, -30, 0, 0);
        _comments.imageEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, 0);
        _comments.userInteractionEnabled = NO;
    }
    return _comments;
}
@end
