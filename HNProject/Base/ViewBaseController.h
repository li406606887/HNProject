//
//  ViewBaseController.h
//  RDFuturesApp
//
//  Created by user on 17/2/28.
//  Copyright © 2017年 FuturesApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewBaseControllerProtocol.h"


@interface ViewBaseController : UIViewController<ViewControllerProtocol>
@property(nonatomic,copy)NSString *centerTitle;


- (void)hideTabbar:(BOOL)hidden;
- (UIView *)centerView;
- (UIBarButtonItem *)leftButton;
- (UIBarButtonItem *)rightButton;

@end
