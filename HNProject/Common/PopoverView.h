//
//  PopoverView.h
//  CleanVehicle
//
//  Created by Sunny on 4/19/15.
//  Copyright (c) 2015 Sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectItemBlock)();

@interface MenuItem : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, copy) SelectItemBlock selectItemBlock;
@property (nonatomic, assign) int index;
@end

@interface PopoverView : UIView
+ (id)sharedInstance;

+ (void)showPopoverViewAtPoint:(CGPoint)point
                     withWidth:(CGFloat)width
				 withMenuItems:(NSArray*)menuItems;

@end
