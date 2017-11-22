//
//  GoodDetailsView.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "GoodDetailsView.h"
#import "GoodDetailsViewModel.h"
#import "DetailsHeadView.h"
#import "DetailsFlowView.h"
#import "PurchaseDescriptionView.h"
#import "PurchaseStateView.h"
#import "SumbitView.h"



@interface GoodDetailsView ()
{
    CGFloat kHeight ;
}
@property(nonatomic,strong) UIScrollView *scroll;
@property(nonatomic,strong) GoodDetailsViewModel *viewModel;
@property(nonatomic,strong) DetailsHeadView *detailsHeadView;
@property(nonatomic,strong) DetailsFlowView *detailsFlowView;
@property(nonatomic,strong) PurchaseDescriptionView *purchaseDescriptionView;
@property(nonatomic,strong) PurchaseStateView *purchaseStateView;
@property(nonatomic,strong) SumbitView *sumbitView;
@property(nonatomic,assign) CGFloat descriptionHeight;
@property(nonatomic,assign) CGFloat stateHeight;

@end

@implementation GoodDetailsView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    kHeight = SCREEN_WIDTH+220;
    self.viewModel = (GoodDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.scroll];
    [self.scroll addSubview:self.detailsHeadView];
    [self.scroll addSubview:self.detailsFlowView];
    [self.scroll addSubview:self.purchaseDescriptionView];
    [self addSubview:self.sumbitView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.detailsHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scroll);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH+90));
    }];
    [self.detailsFlowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailsHeadView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 170));
    }];
    [self.purchaseDescriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.detailsFlowView.mas_bottom).with.offset(10);
        make.width.offset(SCREEN_WIDTH-30);
    }];
    [self.sumbitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 40));
    }];
    
}
-(void)setType:(int)type{
    if (type==0) {
        [self.purchaseDescriptionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(35);
        }];
        //初始contentSize
        _scroll.contentSize = CGSizeMake(0.5, kHeight+self.descriptionHeight);
        [self.scroll mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 40, 0));
        }];
    }else{
        [self.scroll mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.sumbitView setHidden:YES];
        [self.scroll addSubview:self.purchaseStateView];
        [self.purchaseStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.purchaseDescriptionView.mas_bottom).with.offset(10);
            make.width.offset(SCREEN_WIDTH-30);
            make.height.offset(self.stateHeight);
        }];
        self.purchaseStateView.type = type;
        [self.purchaseDescriptionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
        }];
        _scroll.contentSize = CGSizeMake(0.5, kHeight +self.stateHeight+self.descriptionHeight);
    }
    
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        if (self.viewModel.taoPwdArray.count==1) {
            [self.detailsFlowView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(130);
            }];
            kHeight = kHeight+40;
        }else if(self.viewModel.taoPwdArray.count==2){
            [self.detailsFlowView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(170);
            }];
            kHeight = kHeight+80;
        }else {
            [self.detailsFlowView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(90);
            }];
        }
        _scroll.contentSize = CGSizeMake(0.5, kHeight +self.stateHeight+self.descriptionHeight);
    }];
    [self.viewModel.scrollContentSizeSubject subscribeNext:^(NSString *x) {
        @strongify(self)
        self.descriptionHeight = [x floatValue];
        [self.purchaseDescriptionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.descriptionHeight);
        }];
        
        [self.scroll setContentSize:CGSizeMake(0.5, kHeight+self.descriptionHeight+self.stateHeight)];
    }];
    [self.viewModel.tableContentSizeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.stateHeight = [x floatValue];
        [self.purchaseStateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.stateHeight);
        }];
        [self.scroll setContentSize:CGSizeMake(0.5, kHeight+self.descriptionHeight+self.stateHeight)];
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
    }
    return _scroll;
}
-(DetailsHeadView *)detailsHeadView{
    if (!_detailsHeadView) {
        _detailsHeadView = [[DetailsHeadView alloc] initWithViewModel:self.viewModel];
    }
    return _detailsHeadView;
}
-(DetailsFlowView *)detailsFlowView{
    if (!_detailsFlowView) {
        _detailsFlowView = [[DetailsFlowView alloc] initWithViewModel:self.viewModel];
        _detailsFlowView.layer.masksToBounds = YES;
        _detailsFlowView.layer.cornerRadius = 3;
    }
    return _detailsFlowView;
}
-(PurchaseStateView *)purchaseStateView{
    if (!_purchaseStateView) {
        _purchaseStateView = [[PurchaseStateView alloc] initWithViewModel:self.viewModel];
        _purchaseStateView.layer.masksToBounds = YES;
        _purchaseStateView.layer.cornerRadius = 3;
    }
    return _purchaseStateView;
}
-(PurchaseDescriptionView *)purchaseDescriptionView{
    if (!_purchaseDescriptionView) {
        _purchaseDescriptionView = [[PurchaseDescriptionView alloc] initWithViewModel:self.viewModel];
        _purchaseDescriptionView.open = YES;
        _purchaseDescriptionView.layer.masksToBounds = YES;
        _purchaseDescriptionView.layer.cornerRadius = 3;
    }
    return _purchaseDescriptionView;
}
-(CGFloat)descriptionHeight{
    if (!_descriptionHeight) {
        _descriptionHeight = 30.0f;
    }
    return _descriptionHeight;
}
-(CGFloat)stateHeight{
    if (!_stateHeight) {
        _stateHeight = 5;
    }
    return _stateHeight;
}
-(SumbitView *)sumbitView{
    if (!_sumbitView) {
        _sumbitView = [[SumbitView alloc] initWithViewModel:self.viewModel];
    }
    return _sumbitView;
}
@end
