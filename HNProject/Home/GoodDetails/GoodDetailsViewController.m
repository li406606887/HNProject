//
//  GoodDetailsViewController.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "GoodDetailsViewController.h"
#import "SumbitImageViewController.h"
#import "GoodDetailsViewModel.h"
#import "GoodDetailsView.h"

@interface GoodDetailsViewController ()
@property(nonatomic,strong) GoodDetailsView *goodDetailsView;
@property(nonatomic,strong) GoodDetailsViewModel *viewModel;
@property(nonatomic,strong) UIButton *report;//举报
@end

@implementation GoodDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"购买详情"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView{
    [self.view addSubview:self.goodDetailsView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.goodDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)setType:(LoadingAway)type{
    self.report.hidden = type == LoadingAwayStateModify ? NO : YES;
    self.goodDetailsView.type = type;
    self.viewModel.type = type;
}
-(void)setDetailsID:(NSString *)detailsID{
    [self.viewModel.getGoodDetailsCommand execute:detailsID];
}
-(void)setApplysID:(NSString *)applysID{
    [self.viewModel.getApplysCommand execute:applysID];
}
-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.sumbitUISubject subscribeNext:^(id  _Nullable x) {
     @strongify(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认购买" message:@"是否申请购买当前任务?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
            [param setObject:self.viewModel.model.ID forKey:@"project_id"];
            [self.viewModel.applyProjectCommand execute:param];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    [self.viewModel.applySuccessfulSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"申请购买" message:@"申请成功,请耐心等待商家审核,审核成功后前往我的购买跟新任务进度" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"继续购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    [[self.viewModel.sumbitPhotoSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString*  _Nullable x) {
        SumbitImageViewController *sumbitPhoto = [[SumbitImageViewController alloc] init];
        sumbitPhoto.projectID = x;
        [self.navigationController pushViewController:sumbitPhoto animated:YES];
    }];
}
-(UIBarButtonItem *)rightButton {
    return [[UIBarButtonItem alloc] initWithCustomView:self.report];;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(GoodDetailsView *)goodDetailsView{
    if (!_goodDetailsView) {
        _goodDetailsView = [[GoodDetailsView alloc] initWithViewModel:self.viewModel];
    }
    return _goodDetailsView;
}
-(GoodDetailsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[GoodDetailsViewModel alloc] init];
    }
    return _viewModel;
}
-(UIButton *)report {
    if (!_report) {
        _report = [UIButton buttonWithType:UIButtonTypeCustom];
        [_report setFrame:CGRectMake(0, 0, 40, 30)];
        [_report.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_report setTitle:@"举报" forState:UIControlStateNormal];
        [_report setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        @weakify(self)
        [[_report rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"举报内容" preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入举报理由";
                [[textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
                    self.viewModel.reason = x;
                    NSLog(@"s");
                }];
            }];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.viewModel.reportClickCommand execute:nil];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:sure];
            [alertVc addAction:cancel];
            [self presentViewController:alertVc animated:YES completion:nil];
        }];
    }
    return _report;
}
@end
