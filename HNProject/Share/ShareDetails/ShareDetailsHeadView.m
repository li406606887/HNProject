//
//  ShareDetailsHeadView.m
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareDetailsHeadView.h"
#import "ShareDetailsViewModel.h"
#import "ShareDetailsModel.h"

@interface ShareDetailsHeadView ()<UIScrollViewDelegate>
@property(nonatomic,strong) ShareDetailsViewModel *viewModel;
@property(nonatomic,strong) UILabel *pagePrompt;
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *time;
@property(nonatomic,strong) UILabel *centerText;
@property(nonatomic,strong) UIScrollView *shareImageScroll;
@property(nonatomic,strong) UILabel *allComments;
@property(nonatomic,strong) UIButton *like;
@property(nonatomic,strong) UIButton *comments;
@property(nonatomic,assign) int count;
@end

@implementation ShareDetailsHeadView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (ShareDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.icon];
    [self addSubview:self.name];
    [self addSubview:self.time];
    [self addSubview:self.centerText];
    [self addSubview:self.shareImageScroll];
    [self addSubview:self.pagePrompt];
    [self addSubview:self.like];
    [self addSubview:self.comments];
    [self addSubview:self.allComments];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.top.equalTo(self).with.offset(10);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).with.offset(12);
        make.centerY.equalTo(self.icon);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-100, 20));
    }];
    [self.centerText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.icon.mas_bottom).with.offset(10);
        make.width.offset(SCREEN_WIDTH-20);
    }];
    [self.shareImageScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.like.mas_top).with.offset(-10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-20, SCREEN_WIDTH-20));
    }];
    [self.pagePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.bottom.equalTo(self.shareImageScroll.mas_bottom).with.offset(-5);
        make.size.mas_offset(CGSizeMake(40, 20));
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(self.icon);
        make.size.mas_offset(CGSizeMake(140, 20));
    }];
    [self.like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.bottom.equalTo(self.mas_bottom);
        make.size.mas_offset(CGSizeMake(40, 25));
    }];
    [self.comments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.like.mas_left).with.offset(-8);
        make.bottom.equalTo(self.mas_bottom);
        make.size.mas_offset(CGSizeMake(40, 25));
    }];
    [self.allComments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-150, 20));
    }];
    
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.refreshHeadUISubject subscribeNext:^(ShareDetailsModel *  _Nullable model) {
     @strongify(self)
        self.count = (int)model.thumb.count;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:model.user.avatar]
                     placeholderImage:[UIImage imageNamed:@"Personal_Message_Icon"]];
        self.name.text = model.user.taobao_id;
        self.centerText.text = model.content;
        self.like.selected = [model.status intValue]==1 ? YES : NO;
        self.time.text = model.created_at;
        self.allComments.text = [NSString stringWithFormat:@"所有条评论     %@赞",model.zan];
        for (int i = 0 ;i<model.thumb.count;i++) {
            UIImageView *image = [[UIImageView alloc] init];
            [image sd_setImageWithURL:[NSURL URLWithString:model.thumb[i]] placeholderImage:[UIImage imageNamed:@""]];
            image.contentMode = UIViewContentModeScaleAspectFit;
            [self.shareImageScroll addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.shareImageScroll);
                make.left.equalTo(self.shareImageScroll).with.offset((SCREEN_WIDTH-20)*i);
                make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-20, SCREEN_WIDTH-20));
            }];
            image.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [[tap rac_gestureSignal] subscribeNext:^(id x) {
                [self.viewModel.lookBigPhotoSubject sendNext:model.thumb];
            }];
            [image addGestureRecognizer:tap];
        }
        self.pagePrompt.text = [NSString stringWithFormat:@"1/%d",self.count];
        self.shareImageScroll.contentSize = CGSizeMake((SCREEN_WIDTH-20)*model.thumb.count, 0.5f);
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/(SCREEN_WIDTH-20)+1;
    NSLog(@"%d",index);
    self.pagePrompt.text = [NSString stringWithFormat:@"%d/%d",index,self.count];
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
    }
    return _icon;
}

-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont systemFontOfSize:14];
        _name.textColor = RGB(14, 14, 14);
    }
    return _name;
}

-(UILabel *)centerText{
    if (!_centerText) {
        _centerText = [[UILabel alloc] init];
        _centerText.font = [UIFont systemFontOfSize:14];
        _centerText.textColor = RGB(14, 14, 14);
        _centerText.numberOfLines = 0;
    }
    return _centerText;
}

-(UIScrollView *)shareImageScroll{
    if (!_shareImageScroll) {
        _shareImageScroll = [[UIScrollView alloc] init];
        _shareImageScroll.pagingEnabled = YES;
        _shareImageScroll.bounces = NO;
        _shareImageScroll.delegate = self;
    }
    return _shareImageScroll;
}

-(UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.font = [UIFont systemFontOfSize:13];
        _time.textColor = RGB(160, 160, 160);
        _time.textAlignment = NSTextAlignmentRight;
    }
    return _time;
}
-(UILabel *)allComments{
    if (!_allComments) {
        _allComments = [[UILabel alloc] init];
        _allComments.textColor = RGB(170, 170, 170);
        _allComments.font = [UIFont systemFontOfSize:13];
    }
    return _allComments;
}
-(UIButton *)like{
    if (!_like) {
        _like = [UIButton buttonWithType:UIButtonTypeCustom];
        [_like setImage:[UIImage imageNamed:@"Share_Icon_Praise_Normal"] forState:UIControlStateNormal];
        [_like setImage:[UIImage imageNamed:@"Share_Icon_Praise_Selected"] forState:UIControlStateSelected];
        _like.imageEdgeInsets = UIEdgeInsetsMake(5, 12, 5, 12);
    }
    return _like;
}
-(UIButton *)comments{
    if (!_comments) {
        _comments = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comments setImage:[UIImage imageNamed:@"Share_Icon_Comments"] forState:UIControlStateNormal];
        _comments.imageEdgeInsets = UIEdgeInsetsMake(5, 12, 5, 12);
    }
    return _comments;
}
-(UILabel *)pagePrompt{
    if (!_pagePrompt) {
        _pagePrompt = [[UILabel alloc] init];
        _pagePrompt.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _pagePrompt.font = [UIFont systemFontOfSize:13];
        _pagePrompt.textAlignment = NSTextAlignmentCenter;
        _pagePrompt.layer.masksToBounds = YES;
        _pagePrompt.layer.cornerRadius = 10;
    }
    return _pagePrompt;
}
@end
