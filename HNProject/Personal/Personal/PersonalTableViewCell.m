//
//  PersonalTableViewCell.m
//  JYQHProject
//
//  Created by user on 2017/7/7.
//  Copyright © 2017年 zero. All rights reserved.
//

#import "PersonalTableViewCell.h"

@interface PersonalTableViewCell()


@end

@implementation PersonalTableViewCell


-(void)setupViews{
    
    self.textLabel.textColor = RGB(49, 49, 49);
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(200 , 20));
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
