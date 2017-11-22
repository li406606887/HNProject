//
//  ViewBaseControllerProtocol.h
//  RDFuturesApp
//
//  Created by user on 17/3/2.
//  Copyright © 2017年 FuturesApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewProtocol.h"

@protocol ViewControllerProtocol <NSObject>

@optional

-(instancetype)initWithViewModel:(id<BaseViewProtocol>)viewModel ;

-(void)bindViewModel;
-(void)addChildView;
@end
