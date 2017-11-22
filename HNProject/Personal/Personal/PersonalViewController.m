//
//  PersonalViewController.m
//  JYQHProject
//
//  Created by user on 2017/7/6.
//  Copyright © 2017年 zero. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalView.h"
#import "PersonalViewModel.h"
#import "LoginViewController.h"
#import "MessageViewController.h"
#import "PersonalInfoViewController.h"
#import "MyBuyViewController.h"
#import "ModifyPasswordViewController.h"
#import "InviteFriendsViewController.h"
#import "CommonProblemsViewController.h"
#import "HistoryShareViewController.h"
#import "MyGoldViewController.h"


@interface PersonalViewController ()
@property(nonatomic,strong)PersonalView *personalView;
@property(nonatomic,strong)PersonalViewModel *viewModel;
@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //     Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.personalDataUpdateClick sendNext:nil];
}
-(void)addChildView{
    [self.view addSubview:self.personalView];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    WS(weakSelf)
    [self.personalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
}
-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.personalCellClick takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([HNUesrInformation getInformation].hiddenStyle == NO) {
            [self hiddenStyle:[x intValue]];
        }else{
            switch ([x intValue]) {
                case -1: {
                    PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
                    [self.navigationController pushViewController:personalInfo animated:YES];
                }
                    break;
                case 0:{
                    MyBuyViewController *mybuy = [[MyBuyViewController alloc] init];
                    [self.navigationController pushViewController:mybuy animated:YES];
                }
                    break;
                case 1:{
                    MyGoldViewController *mygold = [[MyGoldViewController alloc] init];
                    [self.navigationController pushViewController:mygold animated:YES];
                }
                    break;
                case 2:{
                    HistoryShareViewController *history = [[HistoryShareViewController alloc] init];
                    [self.navigationController pushViewController:history animated:YES];
                }
                    break;
                case 3:{
                    InviteFriendsViewController *inviteFriends = [[InviteFriendsViewController alloc] init];
                    [self.navigationController pushViewController:inviteFriends animated:YES];
                }
                    break;
                case 4:{
                    ModifyPasswordViewController *modifyPwd = [[ModifyPasswordViewController alloc] init];
                    [self.navigationController pushViewController:modifyPwd animated:YES];
                }
                    break;
                case 5:{
                    CommonProblemsViewController *problems = [[CommonProblemsViewController alloc] init];
                    [self.navigationController pushViewController:problems animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
    }];
}

-(UIBarButtonItem *)rightButton {
    if([HNUesrInformation getInformation].hiddenStyle==NO){
        return nil;
    }
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"Navtigation_Message"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionOnTouchMessageButton) forControlEvents:UIControlEventTouchUpInside];//设置按钮的点击事件
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)actionOnTouchMessageButton{
    MessageViewController *message = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:message animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hiddenStyle:(int)index {
    
    switch (index) {
       
        case 0:{
            HistoryShareViewController *history = [[HistoryShareViewController alloc] init];
            [self.navigationController pushViewController:history animated:YES];
        }
            break;
        
        case 1:{
            ModifyPasswordViewController *modifyPwd = [[ModifyPasswordViewController alloc] init];
            [self.navigationController pushViewController:modifyPwd animated:YES];
        }
            break;
        default:
            break;
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
-(PersonalView *)personalView{
    if (!_personalView) {
        _personalView = [[PersonalView alloc] initWithViewModel:self.viewModel];;
    }
    return _personalView;
}
-(PersonalViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[PersonalViewModel alloc] init];
    }
    return _viewModel;
}
@end
