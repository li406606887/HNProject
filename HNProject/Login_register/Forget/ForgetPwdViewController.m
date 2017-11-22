//
//  ForgetPwdViewController.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "ForgetView.h"
#import "ForgetViewModel.h"
@interface ForgetPwdViewController ()
@property(nonatomic,strong) ForgetView *forgetView;
@property(nonatomic,strong) ForgetViewModel *viewModel;
@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"忘记密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView {
    [self.view addSubview:self.forgetView];
}
-(void)updateViewConstraints {
    [super updateViewConstraints];
    [self.forgetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.sumbitDataSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
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

-(ForgetView *)forgetView {
    if (!_forgetView) {
        _forgetView = [[ForgetView alloc] initWithViewModel:self.viewModel];
    }
    return _forgetView;
}
-(ForgetViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ForgetViewModel alloc] init];
    }
    return _viewModel;
}
@end
