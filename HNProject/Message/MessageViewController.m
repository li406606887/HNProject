//
//  MessageViewController.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageViewModel.h"
#import "MessageView.h"
#import "MessageModel.h"
#import "GoodDetailsViewController.h"
#import "ShareDetailsViewController.h"

@interface MessageViewController ()
@property(nonatomic,strong) MessageView *messageView;
@property(nonatomic,strong) MessageViewModel *viewModel;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的消息"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView {
    [self.view addSubview:self.messageView];
}
-(void)updateViewConstraints {
    [super updateViewConstraints];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel {
    @weakify(self)
    [self.viewModel.cellClickSubject subscribeNext:^(MessageModel*  _Nullable model) {
        @strongify(self)
        if ([model.type isEqualToString:@"apply_via"]||[model.type isEqualToString:@"apply_turned"]||[model.type isEqualToString:@"apply_succeed"]||[model.type isEqualToString:@"apply_failed"]) {
            [self gotoGoodDetails:model];
        }else if ([model.type isEqualToString:@"reward"]||[model.type isEqualToString:@"comment_zan"]||[model.type isEqualToString:@"comment"]||[model.type isEqualToString:@"share_zan"]) {
            [self gotoShareDetails:model];
        }
        
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
-(void)gotoGoodDetails:(MessageModel *)model{
    GoodDetailsViewController *details = [[GoodDetailsViewController alloc] init];
    if([model.type isEqualToString:@"apply_via"]) {
        details.type = LoadingAwayStateSumbit;
    }else if ([model.type isEqualToString:@"apply_turned"]) {
        details.type = LoadingAwayStateModify;
        
    }else if ([model.type isEqualToString:@"apply_succeed"]) {
        details.type = LoadingAwayStateComplete;
        
    }else if ([model.type isEqualToString:@"apply_failed"]) {
        details.type = LoadingAwayStateAudit;
    }
    details.applysID = model.type_id;
    [self.navigationController pushViewController:details animated:YES];
    
}
-(void)gotoShareDetails:(MessageModel *)model{
    ShareDetailsViewController *shareDetails = [[ShareDetailsViewController alloc] init];
    shareDetails.detailsId = model.type_id;
    [self.navigationController pushViewController:shareDetails animated:YES];
}
-(MessageView *)messageView{
    if (!_messageView) {
        _messageView = [[MessageView alloc] initWithViewModel:self.viewModel];
    }
    return _messageView;
}

-(MessageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MessageViewModel alloc] init];
    }
    return _viewModel;
}

@end
