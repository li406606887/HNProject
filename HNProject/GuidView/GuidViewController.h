//
//  GuidViewController.h
//  CleanVehicle
//
//  Created by Sunny on 4/15/15.
//  Copyright (c) 2015 Sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidViewController : UIViewController

+ (GuidViewController *)sharedGuide;

+ (void)show;
+ (void)hide;
@end
