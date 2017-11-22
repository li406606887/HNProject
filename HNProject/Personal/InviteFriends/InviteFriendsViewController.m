//
//  InviteFriendsViewController.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "InviteFriendsView.h"
#import "InviteFriendsViewModel.h"

@interface InviteFriendsViewController ()
@property(nonatomic,strong) InviteFriendsView *inviteFriendsView;
@property(nonatomic,strong) InviteFriendsViewModel *viewModel;
@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"邀请好友"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView{
    [self.view addSubview:self.inviteFriendsView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.inviteFriendsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
-(InviteFriendsView *)inviteFriendsView{
    if (!_inviteFriendsView) {
        _inviteFriendsView = [[InviteFriendsView alloc] initWithViewModel:self.viewModel];
    }
    return _inviteFriendsView;
}
-(InviteFriendsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[InviteFriendsViewModel alloc] init];
    }
    return _viewModel;
}
@end
