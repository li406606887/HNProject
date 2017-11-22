//
//  HomeViewController.m
//  JYQHProject
//
//  Created by user on 2017/7/6.
//  Copyright © 2017年 zero. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "HomeView.h"
#import "HomeCollectionModel.h"
#import "GoodDetailsViewController.h"
#import "LoginViewController.h"
#import "GuidViewController.h"
#import "JPUSHService.h"

@interface HomeViewController ()
@property(nonatomic,strong) HomeView *homeView;
@property(nonatomic,strong) HomeViewModel *viewModel;
@property(nonatomic,assign) BOOL loginState;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([HNUesrInformation getInformation].hiddenStyle ==YES) {
        NSString *isLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_LAUNCHED];
        if (isLaunched == nil) {
            [GuidViewController show];
        }
    }
    
    
    if (![[HNUesrInformation getInformation] login]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildView {
    [self.view addSubview:self.homeView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.loginState != [[HNUesrInformation getInformation] login]) {
        [self.viewModel.getBannerDataCommand execute:nil];
        [self.viewModel.getCollectionDataCommand execute:nil];
        self.loginState =[[HNUesrInformation getInformation] login];
    }
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.homeCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(HomeCollectionModel*  _Nullable x) {
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
- (UIView *)centerView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [imageView setImage:[UIImage imageNamed:@"NavigationBar_centerView"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

-(HomeView *)homeView {
    if (!_homeView) {
        _homeView = [[HomeView alloc] initWithViewModel:self.viewModel];
    }
    return _homeView;
}

-(HomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HomeViewModel alloc] init];
    }
    return _viewModel;
}
@end
