//
//  PhotoGroupTableViewCell.m
//  HNProject
//
//  Created by user on 2017/11/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PhotoGroupTableViewCell.h"

@implementation PhotoGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupViews {
    [self.contentView addSubview:self.groupIcon];
    [self.contentView addSubview:self.label];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    [super updateConstraints];
    [self.groupIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).with.offset(10);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groupIcon.mas_right).with.offset(8);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 30));
    }];
}

-(UIImageView *)groupIcon {
    if (!_groupIcon) {
        _groupIcon = [[UIImageView alloc] init];
    }
    return _groupIcon;
}

-(UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16];
    }
    return _label;
}
@end
