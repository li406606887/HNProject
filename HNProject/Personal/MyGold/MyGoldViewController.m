//
//  MyGoldViewController.m
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyGoldViewController.h"
#import "MyBankViewController.h"
#import "MyGoldViewModel.h"
#import "MyGoldView.h"

@interface MyGoldViewController ()
@property(nonatomic,strong) MyGoldView *myGodView;
@property(nonatomic,strong) MyGoldViewModel *viewModel;
@end

@implementation MyGoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的金币"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildView{
    [self.view addSubview:self.myGodView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel.getBankCommand execute:nil];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.myGodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(UIBarButtonItem *)rightButton {
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"Personal_Icon_BankIcon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionOnTouchMessageButton) forControlEvents:UIControlEventTouchUpInside];//设置按钮的点击事件
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
-(void)actionOnTouchMessageButton{
    MyBankViewController *myBank = [[MyBankViewController alloc] init];
    [self.navigationController pushViewController:myBank animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(MyGoldView *)myGodView{
    if (!_myGodView) {
        _myGodView = [[MyGoldView alloc] initWithViewModel:self.viewModel];
    }
    return _myGodView;
}
-(MyGoldViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MyGoldViewModel alloc] init];
    }
    return _viewModel;
}
@end
