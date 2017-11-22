//
//  IndividualitySignatureController.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "IndividualitySignatureController.h"
#import "IndividualitySignatureView.h"
#import "IndividualitySignatureViewModel.h"

@interface IndividualitySignatureController ()
@property(nonatomic,strong) IndividualitySignatureView *individualitySignatureView;
@property(nonatomic,strong) IndividualitySignatureViewModel *viewModel;
@end

@implementation IndividualitySignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"个性签名"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView {
    [self.view addSubview:self.individualitySignatureView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.individualitySignatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    } ];
}
-(UIBarButtonItem *)rightButton{
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(actionOnTouchSaveButton) forControlEvents:UIControlEventTouchUpInside];//设置按钮的点击事件
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
-(void)actionOnTouchSaveButton{
    [self.viewModel.sumbitClickSubject sendNext:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IndividualitySignatureView *)individualitySignatureView{
    if (!_individualitySignatureView) {
        _individualitySignatureView = [[IndividualitySignatureView alloc] initWithViewModel:self.viewModel];
    }
    return _individualitySignatureView;
}

-(IndividualitySignatureViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[IndividualitySignatureViewModel alloc] init];
    }
    return _viewModel;
}
@end
