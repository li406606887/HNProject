//
//  DetailsHeadView.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "DetailsHeadView.h"
#import "GoodDetailsViewModel.h"
#import "GoodDetailsModel.h"

@interface DetailsHeadView()<UIScrollViewDelegate>
@property(nonatomic,strong) GoodDetailsViewModel *viewModel;
@property(nonatomic,strong) UIScrollView *scroll;
@property(nonatomic,strong) UILabel *pagePrompt;
@property(nonatomic,strong) UILabel *goodName;
@property(nonatomic,strong) UILabel *taobaoId;
@property(nonatomic,assign) int count;
@end

@implementation DetailsHeadView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (GoodDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.scroll];
    [self addSubview:self.pagePrompt];
    [self addSubview:self.goodName];
    [self addSubview:self.taobaoId];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
    }];
    [self.pagePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.bottom.equalTo(self.scroll.mas_bottom).with.offset(-5);
        make.size.mas_offset(CGSizeMake(40, 20));
    }];
    [self.goodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.scroll.mas_bottom).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 40));
    }];
    [self.taobaoId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodName.mas_bottom).with.offset(5);
        make.left.equalTo(self).with.offset(15);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 20));
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.pagePrompt.text = [NSString stringWithFormat:@"%d/%d",index+1,self.count];
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.refreshUISubject subscribeNext:^(GoodDetailsModel*  _Nullable model) {
        @strongify(self)
        int i = 0;
        self.count = (int)model.thumb.count;
        for (NSString *url in model.thumb) {
            UIImageView *image = [[UIImageView alloc] init];
            image.contentMode = UIViewContentModeScaleAspectFit;
            [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            [self.scroll addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.scroll);
                make.left.equalTo(self.scroll).with.offset(SCREEN_WIDTH*i);
                make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
            }];
            i++;
        }
        self.pagePrompt.text = [NSString stringWithFormat:@"1/%d",self.count];
        self.goodName.text = model.title.length>0? model.title:@"";
        NSString *taobaoID;
        if ([HNUesrInformation getInformation].hiddenStyle == NO) {
            taobaoID = [NSString stringWithFormat:@"商品ID:%@",model.taobao_id];
        }else{
            taobaoID = [NSString stringWithFormat:@"商品淘宝ID:%@",model.taobao_id];
        }
        self.taobaoId.text = taobaoID;
        _scroll.contentSize = CGSizeMake(SCREEN_WIDTH*self.count, 0.5);

    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIScrollView *)scroll{
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] init];
        _scroll.pagingEnabled = YES;
        _scroll.delegate = self;
    }
    return _scroll;
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

-(UILabel *)goodName{
    if (!_goodName) {
        _goodName = [[UILabel alloc] init];
        _goodName.font = [UIFont systemFontOfSize:14];
        _goodName.textColor = RGB(40, 40, 40);
        _goodName.numberOfLines = 2;
    }
    return _goodName;
}

-(UILabel *)taobaoId{
    if (!_taobaoId) {
        _taobaoId = [[UILabel alloc] init];
        _taobaoId.textColor = [UIColor redColor];
        _taobaoId.font = [UIFont systemFontOfSize:14];
    }
    return _taobaoId;
}
@end
