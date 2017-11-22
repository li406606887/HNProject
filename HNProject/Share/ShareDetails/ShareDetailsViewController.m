//
//  ShareDetailsViewController.m
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareDetailsViewController.h"
#import "ShareDetailsViewModel.h"
#import "ImagePreviewViewController.h"
#import "ShareDetailsView.h"

@interface ShareDetailsViewController ()
@property(nonatomic,strong) ShareDetailsView *shareDetailsView;
@property(nonatomic,strong) ShareDetailsViewModel *viewModel;
@end

@implementation ShareDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"分享详情"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView{
    [self.view addSubview:self.shareDetailsView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.shareDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.getCommentsListCommand execute:nil];
    [[self.viewModel.lookBigPhotoSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray*  _Nullable x) {
        @strongify(self)
        ImagePreviewViewController *vc  = [[ImagePreviewViewController alloc] init];
        vc.imageArray = x;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
-(void)setType:(int)type {
    self.viewModel.type = type;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(ShareDetailsView *)shareDetailsView{
    if (!_shareDetailsView) {
        _shareDetailsView = [[ShareDetailsView alloc] initWithViewModel:self.viewModel];
    }
    return _shareDetailsView;
}
-(ShareDetailsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ShareDetailsViewModel alloc] init];
        _viewModel.detailsID = self.detailsId;
    }
    return _viewModel;
}
@end
