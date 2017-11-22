//
//  SumbitImageViewController.m
//  HNProject
//
//  Created by user on 2017/7/28.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "SumbitImageViewController.h"
#import "SumbitImageView.h"
#import "SumbitImageViewModel.h"
#import <Photos/Photos.h>

@interface SumbitImageViewController ()
@property(nonatomic,strong) SumbitImageView *sumbitView;
@property(nonatomic,strong) SumbitImageViewModel *viewModel;
@end

@implementation SumbitImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"上传截图"];
     [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildView{
    [self.view addSubview:self.sumbitView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    @weakify(self)
    [self.sumbitView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self.view);
    }];
}

-(void)bindViewModel {
    @weakify(self)
    [self.viewModel.successfulSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        showMassage(@"提交成功")
    }];
}

- (UIBarButtonItem *)rightButton
{
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sumbitPhoto) forControlEvents:UIControlEventTouchUpInside];//设置按钮的点击事件
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}
-(void)sumbitPhoto{
    [self.viewModel.sendSumbitSubject sendNext:nil];
}
-(void)setProjectID:(NSString *)projectID {
    self.viewModel.projectID = projectID;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(SumbitImageView *)sumbitView{
    if (!_sumbitView) {
        _sumbitView = [[SumbitImageView alloc] initWithViewModel:self.viewModel];
    }
    return _sumbitView;
}
-(SumbitImageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SumbitImageViewModel alloc] init];
    }
    return _viewModel;
}
@end
