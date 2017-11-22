//
//  CommonProblemsCell.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "CommonProblemsCell.h"

@interface CommonProblemsCell()
@property(nonatomic,strong) UIImageView *questionIcon;
@property(nonatomic,strong) UIImageView *answerIcon;
@property(nonatomic,strong) UILabel *questionLabel;
@property(nonatomic,strong) UILabel *answerLabel;
@end

@implementation CommonProblemsCell

-(void)setupViews{
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 3;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.questionIcon];
    [self.contentView addSubview:self.answerIcon];
    [self.contentView addSubview:self.questionLabel];
    [self.contentView addSubview:self.answerLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 15, 5, 15));
    }];
    [self.questionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(8);
        make.top.equalTo(self.contentView).with.offset(15);
        make.size.mas_offset(CGSizeMake(17, 17));
    }];
    [self.answerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(8);
        make.top.equalTo(self.questionIcon.mas_bottom).with.offset(20);
        make.size.mas_offset(CGSizeMake(17, 17));
    }];
    
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionIcon.mas_right).with.offset(6);
        make.top.equalTo(self.contentView).with.offset(15);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-67, 17));
    }];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionIcon.mas_right).with.offset(4);
        make.top.equalTo(self.questionIcon.mas_bottom).with.offset(20);
        make.width.equalTo(@(SCREEN_WIDTH-67));
    }];
}

-(void)setModel:(CommonProblemsModel *)model{
    if (model) {
        self.questionLabel.text = model.question;
        self.answerLabel.text = model.answer;
    }
}

-(void)setHeight:(CGFloat)height{
    if (height) {
        [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
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

-(UIImageView *)questionIcon{
    if (!_questionIcon) {
        _questionIcon = [[UIImageView alloc] init];
        [_questionIcon setImage:[UIImage imageNamed:@"Personal_Icon_Question"]];
    }
    return _questionIcon;
}
-(UIImageView *)answerIcon{
    if (!_answerIcon) {
        _answerIcon = [[UIImageView alloc] init];
        [_answerIcon setImage:[UIImage imageNamed:@"Personal_Icon_Answer"]];
    }
    return _answerIcon;
}
-(UILabel *)questionLabel{
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.textColor = RGB(30, 30, 30);
        _questionLabel.font = [UIFont systemFontOfSize:13];
    }
    return _questionLabel;
}
-(UILabel *)answerLabel{
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.textColor = RGB(30, 30, 30);
        _answerLabel.font = [UIFont systemFontOfSize:13];
        _answerLabel.numberOfLines = 0;
    }
    return _answerLabel;
}

@end
