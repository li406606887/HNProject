//
//  SegmentControlView.m
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "SegmentControlView.h"
#import "ShareDetailsViewModel.h"
#import "ShareDetailsModel.h"

@interface SegmentControlView ()
@property(nonatomic,strong) ShareDetailsViewModel *viewModel;
@property(nonatomic,assign) CGFloat itemWidth;
//@property(nonatomic,assign) CGFloat linex;
@property(nonatomic,strong) UIButton *praise;
@property(nonatomic,strong) UIButton *comments;
@property(nonatomic,strong) UIButton *reward;
@property(nonatomic,strong) UIImageView *leftLine;
@property(nonatomic,strong) UIImageView *rightLine;
@property(nonatomic,strong) ShareDetailsModel *model;
@end

@implementation SegmentControlView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (ShareDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews{
    [self addSubview:self.praise];
    [self addSubview:self.comments];
    if([HNUesrInformation getInformation].hiddenStyle == YES){
        [self addSubview:self.reward];
    }
    [self addSubview:self.leftLine];
    [self addSubview:self.rightLine];
    [self setBackgroundColor:RGB(47, 47, 47)];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.praise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.size.mas_offset(CGSizeMake(self.itemWidth, 40));
    }];
    [self.comments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(self.itemWidth);
        make.size.mas_offset(CGSizeMake(self.itemWidth, 40));
    }];
    if([HNUesrInformation getInformation].hiddenStyle == YES){
        [self.reward mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(SCREEN_WIDTH*0.66);
            make.size.mas_offset(CGSizeMake(self.itemWidth, 40));
        }];
    }
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.praise.mas_right);
        make.size.mas_offset(CGSizeMake(1, 25));
    }];
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.comments.mas_right);
        make.size.mas_offset(CGSizeMake(1, 25));
    }];
}
-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.isPraiseCommand execute:nil];

    [self.viewModel.refreshHeadUISubject subscribeNext:^(ShareDetailsModel*  _Nullable model) {
        @strongify(self)
        self.model = model;
        if (model.zan.length <1) {
            model.zan = @"0";
        }
        if (model.rewards.length<1) {
            model.rewards = @"0";
        }
        [self.praise setTitle:[NSString stringWithFormat:@"%@",model.zan] forState:UIControlStateNormal];
        [self.reward setTitle:[NSString stringWithFormat:@"%@",model.rewards] forState:UIControlStateNormal];
    }];
    [self.viewModel.refreshHeadUISubject subscribeNext:^(ShareDetailsModel*  _Nullable model) {
        @strongify(self)
        [self.comments setTitle:[NSString stringWithFormat:@"%@",model.comments] forState:UIControlStateNormal];
    }];
    [self.viewModel.praiseRefreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x intValue] == 1) {
            self.praise.selected = YES;
            self.model.zan = self.viewModel.praiseCount;
            [self.praise setTitle:[NSString stringWithFormat:@"%@",self.model.zan] forState:UIControlStateNormal];
            
        }else if([x intValue] == 0){
            self.praise.selected = NO;
            self.model.zan = [NSString stringWithFormat:@"%d",([self.model.zan intValue]-1)];
            [self.praise setTitle:[NSString stringWithFormat:@"%@",self.model.zan] forState:UIControlStateNormal];
        }else if([x intValue] == 2){
            self.praise.selected = YES;
        }else{
            self.praise.selected = NO;
        }
    }];
    [self.viewModel.rewardSuccessfulSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.reward setTitle:[NSString stringWithFormat:@"%@",x] forState:UIControlStateNormal];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIButton *)praise{
    if (!_praise) {
        _praise = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praise setImage:[UIImage imageNamed:@"Share_Icon_Praise_Selected"] forState:UIControlStateSelected];
        [_praise setImage:[UIImage imageNamed:@"Share_Icon_Praise_Normal"] forState:UIControlStateNormal];
        [self.praise setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        @weakify(self)
        [[_praise rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (_praise.selected) {
                [self.viewModel.cancelpraiseCommand execute:nil];
            }else{
                [self.viewModel.praiseCommand execute:nil];
            }
            
        }];
    }
    return _praise;
}
-(UIButton *)comments{
    if (!_comments) {
        _comments = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comments setImage:[UIImage imageNamed:@"Share_Icon_Comments"] forState:UIControlStateNormal];
        [_comments setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];

        @weakify(self)
        [[_comments rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.editorialCommentsSubject sendNext:nil];
            
        }];
    }
    return _comments;
}
-(UIButton *)reward{
    if (!_reward) {
        _reward = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reward setImage:[UIImage imageNamed:@"Share_Reward_Icon"] forState:UIControlStateNormal];
        [_reward setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        @weakify(self)
        [[_reward rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.rewardClickSubject sendNext:nil];
        }];
    }
    return _reward;
}
-(UIImageView *)leftLine{
    if (!_leftLine) {
        _leftLine = [[UIImageView alloc] init];
        [_leftLine setBackgroundColor:[UIColor whiteColor]];
    }
    return _leftLine;
}
-(UIImageView *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UIImageView alloc] init];
        [_rightLine setBackgroundColor:[UIColor whiteColor]];
    }
    return _rightLine;
}
-(CGFloat )itemWidth {
    if (!_itemWidth) {
        if([HNUesrInformation getInformation].hiddenStyle == YES){
            _itemWidth = SCREEN_WIDTH*0.33;
        }else{
            _itemWidth = SCREEN_WIDTH*0.5;
        }
    }
    return _itemWidth;
}
@end
