//
//  HomeCollectionViewCell.m
//  HNProject
//
//  Created by user on 2017/7/13.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell()
@property(nonatomic,strong) UIImageView *detailsImage;
@property(nonatomic,strong) UILabel *goodName;
@property(nonatomic,strong) UIButton *reward;
@property(nonatomic,strong) UILabel *limited;
@property(nonatomic,strong) UILabel *remaining;
@end

@implementation HomeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews {
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.detailsImage];
    [self.contentView addSubview:self.goodName];
    [self.contentView addSubview:self.reward];
    [self.contentView addSubview:self.limited];
    [self.contentView addSubview:self.remaining];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    [super updateConstraints];
    [self.detailsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH*0.5-15, SCREEN_WIDTH*0.5-15));
    }];
    
    [self.goodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(3);
        make.top.equalTo(self.detailsImage.mas_bottom).with.offset(8);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH*0.5-21, 30));
    }];
    
    [self.reward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(-2);
        make.top.equalTo(self.goodName.mas_bottom).with.offset(3);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH*0.5-15)*0.5, 24));
    }];
    
    [self.limited mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-2);
        make.top.equalTo(self.goodName.mas_bottom).with.offset(3);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH*0.5-15)*0.5, 20));
    }];
    [self.remaining mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.reward.mas_bottom).with.offset(3);
        make.size.mas_offset(CGSizeMake((SCREEN_WIDTH*0.5-15), 20));
    }];
}

-(void)setModel:(HomeCollectionModel *)model{
    if (model) {
        [self.detailsImage sd_setImageWithURL:[NSURL URLWithString:model.thumb[0]]
                             placeholderImage:[UIImage imageNamed:@""]];
        self.goodName.text = model.title;
        self.limited.text = [NSString stringWithFormat:@"限量%@份",model.number_of];
        self.remaining.text = [NSString stringWithFormat:@"剩余%@份",model.remain_of];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:RGB(40, 40, 40)};
        NSString * rwad;
        if (![HNUesrInformation getInformation].hiddenStyle == YES) {
            rwad = [NSString stringWithFormat:@"获得%@积分",model.golds];
        }else{
            rwad = [NSString stringWithFormat:@"奖励%@金币",model.golds];
        }
        
        NSMutableAttributedString *atttibuted = [[NSMutableAttributedString alloc] initWithString:rwad attributes:dic];
        [atttibuted addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 2)];
        [self.reward setAttributedTitle:atttibuted forState:UIControlStateNormal];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIImageView *)detailsImage {
    if (!_detailsImage) {
        _detailsImage = [[UIImageView alloc] init];
        _detailsImage.backgroundColor = [UIColor whiteColor];
    }
    return _detailsImage;
}

-(UILabel *)goodName {
    if (!_goodName) {
        _goodName = [[UILabel alloc] init];
        _goodName.text = @"Small cow lamp";
        _goodName.font = [UIFont systemFontOfSize:14];
    }
    return _goodName;
}

-(UIButton *)reward {
    if (!_reward) {
        _reward = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reward setBackgroundImage:[UIImage imageNamed:@"Home_Collection_button_backImage"] forState:UIControlStateNormal];
        _reward.userInteractionEnabled = NO;
    }
    return _reward;
}

-(UILabel *)limited {
    if (!_limited) {
        _limited = [[UILabel alloc] init];
        _limited.textColor = RGB(155, 155, 155);
        _limited.text = @"限量50份";
        _limited.font = [UIFont systemFontOfSize:14];
        _limited.textAlignment = NSTextAlignmentRight;
    }
    return _limited;
}

-(UILabel *)remaining {
    if (!_remaining) {
        _remaining = [[UILabel alloc] init];
        _remaining.text = @"剩余50份";
        _remaining.textColor = RGB(155, 155, 155);
        _remaining.font = [UIFont systemFontOfSize:14];
        _remaining.textAlignment = NSTextAlignmentCenter;
    }
    return _remaining;
}
@end
