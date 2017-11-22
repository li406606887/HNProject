//
//  ModifyPasswordViewController.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "ModifyPasswordViewModel.h"
#import "ModifyPasswordView.h"

@interface ModifyPasswordViewController ()
@property(nonatomic,strong) ModifyPasswordView *modifyPwdView;
@property(nonatomic,strong) ModifyPasswordViewModel *viewModel;
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"忘记密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildView{
    [self.view addSubview:self.modifyPwdView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.modifyPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)bindViewModel {
    @weakify(self)
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
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
-(ModifyPasswordView *)modifyPwdView{
    if (!_modifyPwdView) {
        _modifyPwdView = [[ModifyPasswordView alloc] initWithViewModel:self.viewModel];
    }
    return _modifyPwdView;
}
-(ModifyPasswordViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ModifyPasswordViewModel alloc] init];
    }
    return _viewModel;
}
@end
