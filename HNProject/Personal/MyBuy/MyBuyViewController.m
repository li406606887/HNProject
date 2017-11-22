//
//  MyBuyViewController.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBuyViewController.h"
#import "MyBuyView.h"
#import "MyBuyModel.h"
#import "MyBuyViewModel.h"
#import "GoodDetailsViewController.h"
#import "SumbitImageViewController.h"

@interface MyBuyViewController ()
@property(nonatomic,strong) MyBuyView *myBuyView;
@property(nonatomic,strong) MyBuyViewModel *viewModel;
@end

@implementation MyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的购买"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView{
    [self.view addSubview:self.myBuyView];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.myBuyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.auditCellClickSubJect takeUntil:self.rac_willDeallocSignal] subscribeNext:^(MyBuyModel*  _Nullable x) {
        @strongify(self)
        GoodDetailsViewController *details = [[GoodDetailsViewController alloc] init];
        details.type = LoadingAwayStateAudit;
        details.applysID = x.ID;
        [self.navigationController pushViewController:details animated:YES];
    }];
    [[self.viewModel.modifyCellClickSubJect takeUntil:self.rac_willDeallocSignal] subscribeNext:^(MyBuyModel*  _Nullable x) {
        @strongify(self)
        GoodDetailsViewController *details = [[GoodDetailsViewController alloc] init];
        details.type = LoadingAwayStateModify;
        details.applysID = x.ID;
        [self.navigationController pushViewController:details animated:YES];
    }];
    [[self.viewModel.sumbitCellClickSubJect takeUntil:self.rac_willDeallocSignal] subscribeNext:^(MyBuyModel*  _Nullable x) {
        @strongify(self)
        GoodDetailsViewController *details = [[GoodDetailsViewController alloc] init];
        details.type = LoadingAwayStateSumbit;
        details.applysID = x.ID;
        [self.navigationController pushViewController:details animated:YES];
    }];
    [[self.viewModel.confirmCellClickSubJect takeUntil:self.rac_willDeallocSignal] subscribeNext:^(MyBuyModel*  _Nullable x) {
        @strongify(self)
        GoodDetailsViewController *details = [[GoodDetailsViewController alloc] init];
        details.type = LoadingAwayStateConfirm;
        details.applysID = x.ID;
        [self.navigationController pushViewController:details animated:YES];
    }];
    [[self.viewModel.completedCellClickSubJect takeUntil:self.rac_willDeallocSignal] subscribeNext:^(MyBuyModel*  _Nullable x) {
        @strongify(self)
        GoodDetailsViewController *details = [[GoodDetailsViewController alloc] init];
        details.type = LoadingAwayStateComplete;
        details.applysID = x.ID;
        [self.navigationController pushViewController:details animated:YES];
    }];
    [[self.viewModel.sumbitEditClickSubJect takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString*  _Nullable x) {
        SumbitImageViewController *sumbitPhoto = [[SumbitImageViewController alloc] init];
        sumbitPhoto.projectID = x;
        [self.navigationController pushViewController:sumbitPhoto animated:YES];
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(MyBuyView *)myBuyView {
    if (!_myBuyView) {
        _myBuyView = [[MyBuyView alloc] initWithViewModel:self.viewModel];
    }
    return _myBuyView;
}
-(MyBuyViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MyBuyViewModel alloc] init];
    }
    return _viewModel;
}

@end
