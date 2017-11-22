//
//  NavigationBaseController.m
//  RDFuturesApp
//
//  Created by user on 17/2/28.
//  Copyright © 2017年 FuturesApp. All rights reserved.
//

#import "NavigationBaseController.h"

@interface NavigationBaseController ()
@end

@implementation NavigationBaseController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
//    self.navigationBar.translucent = YES;
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = @[(__bridge id)RGB(253, 192, 9).CGColor, (__bridge id)RGB(239, 208, 94).CGColor];
//    gradientLayer.locations = @[@0.1, @1.0];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1.0, 0);
//    gradientLayer.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
//    [self.navigationBar.layer addSublayer:gradientLayer];
}


/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        viewController.hidesBottomBarWhenPushed = YES;
    }else if(self.childViewControllers.count==0){

    }
    [super pushViewController:viewController animated:animated];
    
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.childViewControllers.count > 1;
}

@end
