//
//  EditBankViewController.m
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "EditBankViewController.h"
#import "EditBankViewModel.h"
#import "EditBankView.h"

@interface EditBankViewController ()
@property(nonatomic,strong) EditBankView *editBankView;
@property(nonatomic,strong) EditBankViewModel *viewModel;

@end

@implementation EditBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"编辑银行卡"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildView{
    [self.view addSubview:self.editBankView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.editBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)setModel:(MyBankModel *)model{
    if (model) {
        [self.viewModel.updateDataSubject sendNext:model];
    }
}

-(void)bindViewModel {
    @weakify(self)
    [self.viewModel.getBankArrayCommand execute:nil];
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)setType:(LoadingType)type{
    if (type == AddBankViewType) {
        self.editBankView.typer = 0;
    }else{
        self.editBankView.typer = 1;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(EditBankView *)editBankView{
    if (!_editBankView) {
        _editBankView = [[EditBankView alloc] initWithViewModel:self.viewModel];
    }
    return _editBankView;
}
-(EditBankViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[EditBankViewModel alloc] init];
    }
    return _viewModel;
}
@end
