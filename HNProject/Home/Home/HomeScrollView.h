//
//  HomeScrollView.h
//  RDFuturesApp
//
//  Created by user on 17/3/3.
//  Copyright © 2017年 FuturesApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface HomeScrollView : BaseView;
@property(nonatomic,strong)NSMutableArray *dataArray;
- (void)addNSTimer;
- (void)removeNSTimer;
@end
