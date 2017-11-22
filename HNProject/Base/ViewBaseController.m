//
//  ViewBaseController.m
//  RDFuturesApp
//
//  Created by user on 17/2/28.
//  Copyright © 2017年 FuturesApp. All rights reserved.
//

#import "ViewBaseController.h"

@interface ViewBaseController ()
@property(nonatomic,strong)UIBarButtonItem *messageItems;
@end

@implementation ViewBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    
    self.view.backgroundColor= DEFAULT_BG_COLOR;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



- (void) setUpNavigationBar
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = RGB(253, 192, 9);
    self.navigationController.navigationBar.barTintColor = RGB(253, 192, 9);
    self.navigationItem.leftBarButtonItem = self.navigationController.childViewControllers.count==1? nil : [self leftButton];//设置导航栏左边按钮
    self.navigationItem.rightBarButtonItem = [self rightButton];
    self.navigationItem.titleView = [self centerView];//设置titel
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (UIBarButtonItem *)leftButton
{
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"Navigation_Back_Icon"] forState:UIControlStateNormal];//设置左边按钮的图片
    [btn addTarget:self action:@selector(actionOnTouchBackButton:) forControlEvents:UIControlEventTouchUpInside];//设置按钮的点击事件
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

- (UIBarButtonItem *)rightButton
{
    return nil;
}

- (UIView *)centerView
{
    return nil;
}

- (void)actionOnTouchBackButton:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideTabbar:(BOOL)hidden
{
    self.tabBarController.tabBar.hidden = hidden;//隐藏导航栏
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    ViewBaseController *vc = [super allocWithZone:zone];
    @weakify(vc);
    [[vc rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        @strongify(vc)
        [vc addChildView];
        [vc bindViewModel];
    }];
    
    [[vc rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        
        
    }];
    
    return vc;
}

-(void)addChildView{
    
}

-(void)bindViewModel{
    
}
-(void)messageBtnClick:(UIButton *)sender {


}
-(UIBarButtonItem *)messageItems{
    if (!_messageItems) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"NavigationBar_Message_Normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"NavigationBar_Message_Selected"] forState:UIControlStateSelected];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _messageItems = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    return _messageItems;
}

@end
