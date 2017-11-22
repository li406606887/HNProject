//
//  HistoryShareCollectionViewCell.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HistoryShareCollectionViewCell.h"

@interface HistoryShareCollectionViewCell()
@property(nonatomic,strong) UIImageView *detailsImage;
@property(nonatomic,strong) UILabel *goodName;
@property(nonatomic,strong) UILabel *timeLabel;
@end

@implementation HistoryShareCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews {
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.detailsImage];
    [self addSubview:self.goodName];
    [self addSubview:self.timeLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    [super updateConstraints];
    [self.detailsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH*0.5-15, SCREEN_WIDTH*0.5-15));
    }];
    
    [self.goodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.detailsImage.mas_bottom).with.offset(8);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH*0.5-15, 30));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(-3);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH*0.5-15, 20));
    }];
}
-(void)setModel:(HistoryShareModel *)model{
    if (model) {
        _model = model;
        [self.detailsImage sd_setImageWithURL:[NSURL URLWithString:model.thumb[0]] placeholderImage:[UIImage imageNamed:@""]];
        self.goodName.text = [NSString stringWithFormat:@"%@",model.title];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",model.created_at];
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
        _detailsImage.backgroundColor = [UIColor grayColor];
    }
    return _detailsImage;
}

-(UILabel *)goodName {
    if (!_goodName) {
        _goodName = [[UILabel alloc] init];
        _goodName.text = @"Small cow lamp";
        _goodName.textAlignment = NSTextAlignmentCenter;
    }
    return _goodName;
}



-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGB(155, 155, 155);
        _timeLabel.text = @"2017.08.08 08:00";
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

@end
