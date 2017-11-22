//
//  ShareViewController.m
//  HNProject
//
//  Created by user on 2017/7/13.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareView.h"
#import "ShareViewModel.h"
#import "ShareModel.h"
#import "PublishShareViewController.h"
#import "ShareDetailsViewController.h"
#import "LoginViewController.h"


#define FirstPrompt @"ShareFirst"

@interface ShareViewController ()
@property(nonatomic,strong) ShareView *shareView;
@property(nonatomic,strong) ShareViewModel *viewModel;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![[HNUesrInformation getInformation] login]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FirstPrompt] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:FirstPrompt forKey:FirstPrompt];
        [self loadingPrompt];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView{
    [self.view addSubview:self.shareView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(ShareModel*  _Nullable model) {
     @strongify(self)
        ShareDetailsViewController *shareDetails = [[ShareDetailsViewController alloc] init];
        shareDetails.detailsId = [NSString stringWithFormat:@"%@",model.ID];
        shareDetails.type = 1;
        [self.navigationController pushViewController:shareDetails animated:YES];
    }];
}

-(UIBarButtonItem *)rightButton {
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"Personal_Icon_ModifyBank"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionOnTouchMessageButton) forControlEvents:UIControlEventTouchUpInside];//设置按钮的点击事件
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
-(void)actionOnTouchMessageButton{
    PublishShareViewController *publishShare = [[PublishShareViewController alloc] init];
    [self.navigationController pushViewController:publishShare animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadingPrompt {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"在这里,你可以记录生活中的趣事,也可以分享使用平台的秘籍" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}

-(ShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareView alloc] initWithViewModel:self.viewModel];
    }
    return _shareView;
}
-(ShareViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ShareViewModel alloc] init];
    }
    return _viewModel;
}
@end
