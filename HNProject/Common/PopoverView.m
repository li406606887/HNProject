//
//  PopoverView.m
//  CleanVehicle
//
//  Created by Sunny on 4/19/15.
//  Copyright (c) 2015 Sunny. All rights reserved.
//

#import "PopoverView.h"

#define SPACE 2.f
#define ROW_HEIGHT 44.f
#define MAX_HEIGHT 300

@implementation MenuItem
@end

@interface PopoverView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* menuItems;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* handerView;
@property (nonatomic) CGFloat popViewWidth;
@end

@implementation PopoverView

+ (void)showPopoverViewAtPoint:(CGPoint)point
                     withWidth:(CGFloat)width
                 withMenuItems:(NSArray *)menuItems
{
    PopoverView* popoverView = [PopoverView sharedInstance];
    popoverView.menuItems = menuItems;
    popoverView.popViewWidth = width;
    [popoverView resetPopoverViewFrame];
    [popoverView.tableView reloadData];
    [popoverView show];
}

+ (id)sharedInstance
{
    static PopoverView* popoerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popoerView = [PopoverView new];
    });
    
    return popoerView;
}


-(void)show
{
    //弹出视图抖动动画
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setAlpha:0.4];
    [_handerView setBackgroundColor:[UIColor blackColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_handerView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    
}

-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (animate)
    {
        [_handerView removeFromSuperview];
        [self removeFromSuperview];
        return;
    }
    
//    [UIView animateWithDuration:0.3f animations:^{
//        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
//        self.alpha = 0.f;
//    } completion:^(BOOL finished) {
//        self.transform = CGAffineTransformIdentity;
//        [_handerView removeFromSuperview];
//        [self removeFromSuperview];
//    }];
}

- (id)init
{
    if (self = [super init])
    {
        [self addSubview:self.tableView];
    }
    
    return self;
}

- (void)resetPopoverViewFrame
{
    
    CGFloat height = self.menuItems.count * ROW_HEIGHT + SPACE;
    if (height > MAX_HEIGHT)
    {
        height = MAX_HEIGHT;
    }
    
    CGPoint point = [UIApplication sharedApplication].keyWindow.center;
    CGRect frame = CGRectMake(point.x - 140, point.y - (height*0.5), self.popViewWidth, height);
    self.frame = frame;
    self.tableView.frame = self.bounds;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    MenuItem* item = [self.menuItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem* item = [self.menuItems objectAtIndex:indexPath.row];
    if (item.selectItemBlock){
        item.selectItemBlock(item);
    }
    [self dismiss];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.layer.borderColor = RGB(225.0, 225.0, 225.0).CGColor;
        _tableView.layer.borderWidth = 1.0f;
        
    }
    return _tableView;
}
@end
