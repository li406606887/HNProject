//
//  MyBankViewController.m
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBankViewController.h"
#import "MyBankView.h"
#import "MyBankViewModel.h"
#import "EditBankViewController.h"

@interface MyBankViewController ()
@property(nonatomic,strong) MyBankView *myBankView;
@property(nonatomic,strong) MyBankViewModel *viewModel;
@end

@implementation MyBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的银行卡"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel.getAllBankCommand execute:nil];
}
-(void)addChildView{
    [self.view addSubview:self.myBankView];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.myBankView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.addBankCardClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        EditBankViewController *edit = [[EditBankViewController alloc] init];
        edit.type = AddBankViewType;
        [self.navigationController pushViewController:edit animated:YES];
    }];
    
    [[self.viewModel.bankEditSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(MyBankModel*  _Nullable model) {
        @strongify(self);
        EditBankViewController *edit = [[EditBankViewController alloc] init];
        edit.type = EditBankViewType;
        edit.model = model;
        [self.navigationController pushViewController:edit animated:YES];
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

-(MyBankView *)myBankView{
    if (!_myBankView) {
        _myBankView = [[MyBankView alloc] initWithViewModel:self.viewModel];
    }
    return _myBankView;
}

-(MyBankViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MyBankViewModel alloc] init];
    }
    return _viewModel;
}
@end
