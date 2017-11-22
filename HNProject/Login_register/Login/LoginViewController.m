//
//  LoginViewController.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPwdViewController.h"
#import "RegisterViewController.h"
#import "LoginView.h"
#import "LoginViewModel.h"

@interface LoginViewController ()
@property(nonatomic,strong) LoginView  *loginView;
@property(nonatomic,strong) LoginViewModel *viewModel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"登录"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildView {
    [self.view addSubview:self.loginView];
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(UIBarButtonItem *)leftButton{
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];}
-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.forgetClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        ForgetPwdViewController *forget = [[ForgetPwdViewController alloc] init];
        [self.navigationController pushViewController:forget animated:YES];
    }];
    
    [[self.viewModel.loginSuccessfulSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(UIBarButtonItem *)rightButton {
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btn setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionOnTouchBackButton) forControlEvents:UIControlEventTouchUpInside];//设置按钮的点击事件
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)actionOnTouchBackButton{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(LoginView *)loginView {
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithViewModel:self.viewModel];
    }
    return _loginView;
}

-(LoginViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}
@end
