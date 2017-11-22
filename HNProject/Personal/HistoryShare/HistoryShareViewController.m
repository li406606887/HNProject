//
//  HistoryShareViewController.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HistoryShareViewController.h"
#import "HistoryShareView.h"
#import "HistoryShareViewModel.h"
#import "ShareDetailsViewController.h"
#import "HistoryShareModel.h"

@interface HistoryShareViewController ()
@property(nonatomic,strong) HistoryShareViewModel *viewModel;
@property(nonatomic,strong) HistoryShareView *historyShareView;
@end

@implementation HistoryShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"历史分享"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView{
    [self.view addSubview:self.historyShareView];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.historyShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(HistoryShareModel*  _Nullable model) {
        @strongify(self)
        ShareDetailsViewController *shareDetails = [[ShareDetailsViewController alloc] init];
        shareDetails.detailsId = model.ID;
        shareDetails.type = 2;
        [self.navigationController pushViewController:shareDetails animated:YES];
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
-(HistoryShareView *)historyShareView{
    if (!_historyShareView) {
        _historyShareView = [[HistoryShareView alloc] initWithViewModel:self.viewModel];
    }
    return _historyShareView;
}
-(HistoryShareViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HistoryShareViewModel alloc] init];
    }
    return _viewModel;
}
@end
