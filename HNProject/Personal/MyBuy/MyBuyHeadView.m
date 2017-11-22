//
//  MyBuyHeadView.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBuyHeadView.h"
#import "MyBuyViewModel.h"

@interface MyBuyHeadView()<UIScrollViewDelegate>
@property(nonatomic,strong) MyBuyViewModel *viewModel;
@property(nonatomic,strong) UISegmentedControl *segmentedControl;
@property(nonatomic,strong) UIScrollView *segSrollLineView;
@property(nonatomic,strong) UIView *lineView;
@end

@implementation MyBuyHeadView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel {
    self.viewModel = (MyBuyViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews{
    [self addSubview:self.segmentedControl];
    [self addSubview:self.segSrollLineView];
    [self.segSrollLineView addSubview:self.lineView];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 40));
    }];
    
    [self.segSrollLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 2));
    }];
}

-(UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"待审核",@"待提交",@"待修改",@"待确认",@"已完成",nil]];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.tintColor = [UIColor clearColor];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                    NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                         forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                    NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                         forState:UIControlStateSelected];
        [_segmentedControl addTarget:self action:@selector(segmentedControlClick) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

-(void)segmentedControlClick{
    int index = (int)self.segmentedControl.selectedSegmentIndex;
    [self.viewModel.segmentClickSubject sendNext:[NSString stringWithFormat:@"%d",index]];
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat offsetY = index * SCREEN_WIDTH*0.2+10;
        self.lineView.frame = CGRectMake(offsetY, 0, SCREEN_WIDTH*0.2-20, 2);
    } completion:^(BOOL finished) {
    }];
}

-(UIScrollView *)segSrollLineView {
    if (!_segSrollLineView) {
        _segSrollLineView = [[UIScrollView alloc] init];
        _segSrollLineView.backgroundColor = [UIColor whiteColor];
        _segSrollLineView.delegate = self;
        _segSrollLineView.userInteractionEnabled = NO;
        _segSrollLineView.pagingEnabled = YES;
        _segSrollLineView.contentSize = CGSizeMake(-SCREEN_WIDTH*2, 0.5f);
    }
    return _segSrollLineView;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH*0.2-20, 2)];
        [_lineView setBackgroundColor:[UIColor blackColor]];
    }
    return _lineView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
@end
