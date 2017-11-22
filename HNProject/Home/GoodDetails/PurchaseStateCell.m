//
//  PurchaseStateCell.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PurchaseStateCell.h"

@interface PurchaseStateCell ()
@end

@implementation PurchaseStateCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setupViews {
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.instruction];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(65, 20));
    }];
    [self.instruction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right).with.offset(5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(200, 20));
    }];
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = RGB(40, 40, 40);
    }
    return _title;
}
-(UILabel *)instruction{
    if (!_instruction) {
        _instruction = [[UILabel alloc] init];
        _instruction.font = [UIFont systemFontOfSize:14];
        _instruction.textColor = RGB(40, 40, 40);
    }
    return _instruction;
}
@end
