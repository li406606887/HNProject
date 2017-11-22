//
//  PersonalInfoTableViewCell.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PersonalInfoTableViewCell.h"

@interface PersonalInfoTableViewCell ()

@end

@implementation PersonalInfoTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    [self setupViews];
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}
-(void)setupViews {
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextLabel.textColor = [UIColor blackColor];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
}
-(void)bindViewModel {
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface PersonalInfoIconTableViewCell()
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *title;
@end

@implementation PersonalInfoIconTableViewCell

-(void)setupViews {
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.icon];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(100, 20));
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
}
-(void)bindViewModel {
    
}
-(void)setIconUrl:(NSString *)iconUrl{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"Personal_Message_Icon"]];
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
        [_icon setImage:[UIImage imageNamed:@"Personal_Message_Icon"]];
    }
    return _icon;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.text = @"头像";
    }
    return _title;
}
@end
