//
//  RegisterViewController.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "RegisterViewModel.h"
#import "UserAgreementViewController.h"

@interface RegisterViewController ()
@property(nonatomic,strong) RegisterView *registerView;
@property(nonatomic,strong) RegisterViewModel *viewModel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"注册"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildView {
    [self.view addSubview:self.registerView];
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel {
    @weakify(self)
    [[self.viewModel.userAgreementClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        UserAgreementViewController *user = [[UserAgreementViewController alloc] init];
        [self.navigationController pushViewController:user animated:YES];
    }];
    [[self.viewModel.registerSuccessfulClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
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
-(RegisterView *)registerView{
    if (!_registerView) {
        _registerView = [[RegisterView alloc] initWithViewModel:self.viewModel];
    }
    return _registerView;
}
-(RegisterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RegisterViewModel alloc] init];
    }
    return _viewModel;
}

@end
