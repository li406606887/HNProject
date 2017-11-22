//
//  BaseTabBarViewController.m
//  JYQHProject
//
//  Created by user on 2017/7/6.
//  Copyright © 2017年 zero. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "HomeViewController.h"
#import "PersonalViewController.h"
#import "NavigationBaseController.h"
#import "GrabCouponViewController.h"
#import "ShareViewController.h"
#import "HNTabBar.h"
#import "NotifyModel.h"
#import "LoginViewController.h"
#import "GoodDetailsViewController.h"
#import "ShareDetailsViewController.h"

@interface BaseTabBarViewController ()<UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self setValue:[[HNTabBar alloc] init] forKeyPath:@"tabBar"];
    self.tabBar.barTintColor = RGB(37, 37, 37);
    self.tabBar.backgroundColor = RGB(37, 37, 37);

    [self registerNotify];
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSDictionary *attrs =@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    
    NSDictionary *selectedAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:DEFAULT_COLOR};
    
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    /*
     * 添加子导航栏控制器
     */
    if([HNUesrInformation getInformation].hiddenStyle == YES){
        [self setupChildVc:[[HomeViewController alloc] init] title:@"免单购" image:@"TabBar_Preferential_Normal" selectedImage:@"TabBar_Preferential_Selected"];
        [self setupChildVc:[[GrabCouponViewController alloc] init] title:@"暗语购" image:@"TabBar_GrabCoupon_Normal" selectedImage:@"TabBar_GrabCoupon_Selected"];
    }
    [self setupChildVc:[[ShareViewController alloc] init] title:@"分享" image:@"TabBar_Share_Normal" selectedImage:@"TabBar_Share_Selected"];
    [self setupChildVc:[[PersonalViewController alloc] init] title:@"我的" image:@"TabBar_Personal_Normal" selectedImage:@"TabBar_Personal_Selected"];
    
    
    
}

-(void)registerNotify {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"GoodDetailsNotification" object:nil] subscribeNext:^(NSNotification *notification) {
        if (![notification.name isEqualToString:@"GoodDetailsNotification"]) {
            return ;
        }
        NotifyModel *model = (NotifyModel *)notification.object;
        NavigationBaseController *nav = self.childViewControllers[self.selectedIndex];
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
        [nav pushViewController:details animated:YES];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ShareNotification" object:nil] subscribeNext:^(NSNotification *notification) {
        if (![notification.name isEqualToString:@"ShareNotification"]) {
            return ;
        }
        NotifyModel *model = (NotifyModel *)notification.object;
        NavigationBaseController *nav = self.childViewControllers[self.selectedIndex];
        ShareDetailsViewController *shareDetails = [[ShareDetailsViewController alloc] init];
        shareDetails.detailsId = model.type_id;
        [nav pushViewController:shareDetails animated:YES];
    }];
}

- (UINavigationController *)yq_navigationController {
    return self.selectedViewController;
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;

    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    NavigationBaseController *nav = [[NavigationBaseController alloc] initWithRootViewController:vc];
    
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    [nav.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(51, 51, 51),
                                                NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                                }];
   
    [self addChildViewController:nav];
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}

@end
