//
//  MyBuyTableViewCell.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBuyTableViewCell.h"
#import "MyBuyModel.h"

@interface MyBuyTableViewCell()
@property(nonatomic,strong) UIImageView *goodIcon;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *details;
@property(nonatomic,strong) UILabel *num;//数量
@property(nonatomic,strong) UILabel *state;//状态
@end

@implementation MyBuyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

-(void)setupViews{
    [self.contentView addSubview:self.goodIcon];
    [self.contentView addSubview:self.num];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.details];
    [self.contentView addSubview:self.state];
    [self.contentView addSubview:self.operationButton];
   
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.goodIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.goodIcon.mas_right).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-150, 20));
    }];
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).with.offset(5);
        make.left.equalTo(self.goodIcon.mas_right).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-150, 20));
    }];
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.left.equalTo(self.goodIcon.mas_right).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-200, 20));
    }];
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.size.mas_offset(CGSizeMake(50, 20));
    }];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView).with.offset(-5);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
}
-(void)setStateString:(NSString *)stateString{
    _stateString = stateString;
}
-(void)setModel:(MyBuyModel *)model{
    if (model) {
        _model = model;
        [self.goodIcon sd_setImageWithURL:[NSURL URLWithString:model.project.thumb[0]] placeholderImage:[UIImage imageNamed:@""]];
        self.title.text = model.project.title;
        NSString *taobao_ID = [NSString stringWithFormat:@"商品淘宝ID:%@",model.project.taobao_id];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:taobao_ID attributes:nil];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7, taobao_ID.length-7)];
        self.details.attributedText = attributed;
        self.num.text = [NSString stringWithFormat:@"x1"];//model.project.number_of
        self.state.text = _stateString;
      
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UILabel *)num {
    if (!_num) {
        _num = [[UILabel alloc] init];
        _num.textColor = RGB(179, 179, 179);
        _num.font = [UIFont systemFontOfSize:13];
        _num.textAlignment = NSTextAlignmentRight;
    }
    return _num;
}

-(UILabel *)state {
    if (!_state) {
        _state = [[UILabel alloc] init];
        _state.textColor = [UIColor redColor];
        _state.font = [UIFont systemFontOfSize:14];
    }
    return _state;
}
-(UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationButton setBackgroundColor:DEFAULT_COLOR];
        _operationButton.layer.masksToBounds = YES;
        _operationButton.layer.cornerRadius = 3;
        [_operationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_operationButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        @weakify(self)
        [[_operationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.sumbitEditClickSubJect sendNext:self.model.ID];
        }];
    }
    return _operationButton;
}
-(UIImageView *)goodIcon{
    if (!_goodIcon) {
        _goodIcon = [[UIImageView alloc] init];
    }
    return _goodIcon;
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = RGB(40, 40, 40);

    }
    return _title;
}
-(UILabel *)details{
    if (!_details) {
        _details = [[UILabel alloc] init];
        _details.font = [UIFont systemFontOfSize:12];
        _details.textColor = RGB(40, 40, 40);
    }
    return _details;
}
@end
