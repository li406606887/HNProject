//
//  BaseView.m
//  RDFuturesApp
//
//  Created by user on 17/3/1.
//  Copyright © 2017年 FuturesApp. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    
    self = [super init];
    if (self) {
        [self setupViews];
        [self bindViewModel];
    }
    return self;
}


- (void)bindViewModel {
    
}

- (void)setupViews {

}

@end
