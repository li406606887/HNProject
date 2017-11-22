//
//  GrabCouponViewController.m
//  HNProject
//
//  Created by user on 2017/7/13.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "GrabCouponViewController.h"
#import "GrabCouponView.h"
#import "GrabCouponViewModel.h"
#import "GoodDetailsViewController.h"
#import "HomeCollectionModel.h"

@interface GrabCouponViewController ()
@property(nonatomic,strong) GrabCouponView *grabCouponView;
@property(nonatomic,strong) GrabCouponViewModel *viewModel;
@end

@implementation GrabCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView{
    [self.view addSubview:self.grabCouponView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.grabCouponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.detailsCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(HomeCollectionModel*  _Nullable x) {
        @strongify(self)
        GoodDetailsViewController *details = [[GoodDetailsViewController alloc] init];
        details.type = LoadingAwayStateBuy;
        details.detailsID = x.ID;
        [self.navigationController pushViewController:details animated:YES];
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
-(GrabCouponView *)grabCouponView{
    if (!_grabCouponView) {
        _grabCouponView = [[GrabCouponView alloc] initWithViewModel:self.viewModel];
    }
    return _grabCouponView;
}
-(GrabCouponViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[GrabCouponViewModel alloc] init];
    }
    return _viewModel;
}
@end
