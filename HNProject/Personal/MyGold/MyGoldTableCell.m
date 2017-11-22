//
//  MyGoldTableCell.m
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyGoldTableCell.h"

@interface MyGoldTableCell()
@property(nonatomic,strong) UIImageView *goldIcon;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *remainingNum;
@end

@implementation MyGoldTableCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}
-(void)setupViews {

    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.goldIcon];
    [self.contentView addSubview:self.remainingNum];
    self.detailTextLabel.textColor = RGB(150, 150, 150);
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
//        make.size.mas_offset(CGSizeMake(<#CGFloat width#>, <#CGFloat height#>))
    }];
    [self.goldIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).with.offset(-10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(10, 14));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goldIcon.mas_left).with.offset(-2);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(30, 14));
    }];
    [self.remainingNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goldIcon.mas_right).with.offset(2);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(100, 14));
    }];
}
-(void)setModel:(MyGoldModel *)model{
    if (model) {
        self.remainingNum.text = [NSString stringWithFormat:@"%@",model.balance];
        NSString *remarks = [model.remarks substringToIndex:4];
        NSString *string;
        if ([model.type isEqualToString:@"expend"]) {
            string = [NSString stringWithFormat:@"%@-%@",remarks,model.amount];
        }else{
            string = [NSString stringWithFormat:@"%@+%@",remarks,model.amount];
        }
        NSMutableAttributedString *attrobuted = [[NSMutableAttributedString alloc] initWithString:string attributes:nil];
        [attrobuted addAttribute:NSForegroundColorAttributeName value:RGB(200, 200, 200) range:NSMakeRange(0, remarks.length)];
        self.textLabel.attributedText = attrobuted;
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.created_at];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"剩余";
        _title.textColor = RGB(155, 155, 155);
        _title.font = [UIFont systemFontOfSize:13];
        _title.textAlignment = NSTextAlignmentRight;
    }
    return _title;
}
-(UIImageView *)goldIcon{
    if (!_goldIcon) {
        _goldIcon = [[UIImageView alloc] init];
        _goldIcon.image = [UIImage imageNamed:@"Personal_Icon_Gold"];
    }
    return _goldIcon;
}
-(UILabel *)remainingNum{
    if (!_remainingNum) {
        _remainingNum = [[UILabel alloc] init];
        _remainingNum.text = @"12345";
        _remainingNum.font = [UIFont systemFontOfSize:13];
    }
    return _remainingNum;
}
@end
