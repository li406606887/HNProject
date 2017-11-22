//
//  CommonProblemsViewController.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "CommonProblemsViewController.h"
#import "CommonProblemsViewModel.h"
#import "CommonProblemsView.h"

@interface CommonProblemsViewController ()
@property(nonatomic,strong) CommonProblemsViewModel *viewModel;
@property(nonatomic,strong) CommonProblemsView *commonProblemsView;
@end

@implementation CommonProblemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"常见问题"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView{
    [self.view addSubview:self.commonProblemsView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.commonProblemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel {
    @weakify(self)
    [[self.viewModel.callPhoneSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
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
-(CommonProblemsView *)commonProblemsView{
    if (!_commonProblemsView) {
        _commonProblemsView = [[CommonProblemsView alloc] initWithViewModel:self.viewModel];
    }
    return _commonProblemsView;
}
-(CommonProblemsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[CommonProblemsViewModel alloc] init];
    }
    return _viewModel;
}
@end
