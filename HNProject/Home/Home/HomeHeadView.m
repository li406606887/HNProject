//
//  HomeHeadView.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HomeHeadView.h"
#import "HomeScrollView.h"
#import "HomeViewModel.h"

@interface HomeHeadView()
@property(nonatomic,strong) HomeViewModel *viewModel;
@property(nonatomic,strong) HomeScrollView *scrollView;
@property(nonatomic,strong) UIView *sectionView;
@end

@implementation HomeHeadView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel {
    self.viewModel = (HomeViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews {
    [self addSubview:self.scrollView];
    [self addSubview:self.sectionView];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    [super updateConstraints];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*0.5));
    }];
    
    [self.sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.scrollView.mas_bottom);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 50));
    }];
}

-(void)bindViewModel {
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(HomeScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[HomeScrollView alloc] initWithViewModel:self.viewModel];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

-(UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
        _sectionView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        UILabel *title = [[UILabel alloc] init];
        [title setText:@"申请购买"];
        title.textAlignment = NSTextAlignmentCenter;
        [title setBackgroundColor:[UIColor whiteColor]];
        [_sectionView addSubview:line];
        [_sectionView addSubview:title];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_sectionView);
            make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 1));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_sectionView);
            make.size.mas_offset(CGSizeMake(100, 30));
        }];
    }
    return _sectionView;
}
@end
