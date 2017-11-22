//
//  MyBuyView.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBuyView.h"
#import "MyBuyHeadView.h"
#import "MyBuyViewModel.h"
#import "PendingAuditView.h"
#import "PendingSumbitView.h"
#import "PendingModifyView.h"
#import "PendingConfirmView.h"
#import "CompletedView.h"

@interface MyBuyView ()
@property(nonatomic,strong) MyBuyHeadView *myBuyHeadView;
@property(nonatomic,strong) MyBuyViewModel *viewModel;
@property(nonatomic,strong) PendingAuditView *pendingAuditView;
@property(nonatomic,strong) PendingSumbitView *pendingSumbitView;
@property(nonatomic,strong) PendingModifyView *pendingModifyView;
@property(nonatomic,strong) PendingConfirmView *pendingConfirmView;
@property(nonatomic,strong) CompletedView *completedView;
@property(nonatomic,weak) BaseView *oldView;
@end

@implementation MyBuyView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (MyBuyViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews {
    [self addSubview:self.myBuyHeadView];
    [self addSubview:self.pendingAuditView];
    self.oldView = self.pendingAuditView;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.myBuyHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 42));
    }];
    [self.oldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myBuyHeadView.mas_bottom);
        make.centerX.equalTo(self);
        make.width.equalTo(@SCREEN_WIDTH);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}
-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.segmentClickSubject subscribeNext:^(id  _Nullable x) {
     @strongify(self)
        switch ([x intValue]) {
            case 0:
                [self.oldView removeFromSuperview];
                [self addSubview:self.pendingAuditView];
                self.oldView = self.pendingAuditView;
                break;
            case 1:
                [self.oldView removeFromSuperview];
                [self addSubview:self.pendingSumbitView];
                self.oldView = self.pendingSumbitView;
                break;
            case 2:
                [self.oldView removeFromSuperview];
                [self addSubview:self.pendingModifyView];
                self.oldView = self.pendingModifyView;
                break;
            case 3:
                [self.oldView removeFromSuperview];
                [self addSubview:self.pendingConfirmView];
                self.oldView = self.pendingConfirmView;
                break;
            case 4:
                [self.oldView removeFromSuperview];
                [self addSubview:self.completedView];
                self.oldView = self.completedView;
                break;
                
            default:
                break;
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(MyBuyHeadView *)myBuyHeadView{
    if (!_myBuyHeadView) {
        _myBuyHeadView = [[MyBuyHeadView alloc] initWithViewModel:self.viewModel];
    }
    return _myBuyHeadView;
}
-(PendingAuditView *)pendingAuditView{
    if (!_pendingAuditView) {
        _pendingAuditView = [[PendingAuditView alloc] initWithViewModel:self.viewModel];
        _pendingAuditView.backgroundColor = [UIColor whiteColor];
    }
    return _pendingAuditView;
}
-(PendingSumbitView *)pendingSumbitView{
    if (!_pendingSumbitView) {
        _pendingSumbitView = [[PendingSumbitView alloc] initWithViewModel:self.viewModel];
        _pendingSumbitView.backgroundColor = [UIColor whiteColor];
    }
    return _pendingSumbitView;
}
-(PendingModifyView *)pendingModifyView{
    if (!_pendingModifyView) {
        _pendingModifyView = [[PendingModifyView alloc] initWithViewModel:self.viewModel];
        _pendingModifyView.backgroundColor = [UIColor whiteColor];
    }
    return _pendingModifyView;
}
-(PendingConfirmView *)pendingConfirmView{
    if (!_pendingConfirmView) {
        _pendingConfirmView = [[PendingConfirmView alloc] initWithViewModel:self.viewModel];
        _pendingConfirmView.backgroundColor = [UIColor whiteColor];
    }
    return _pendingConfirmView;
}
-(CompletedView *)completedView{
    if (!_completedView) {
        _completedView = [[CompletedView alloc] initWithViewModel:self.viewModel];
        _completedView.backgroundColor = [UIColor whiteColor];
    }
    return _completedView;
}
@end
