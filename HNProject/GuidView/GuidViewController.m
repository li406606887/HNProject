//
//  GuidViewController.m
//
//
//  Created by Sunny on 4/15/15.
//  Copyright (c) 2015 Sunny. All rights reserved.
//  摘要  欢迎界面的图片以及内容
//

#import "GuidViewController.h"



@interface GuidViewController ()<UIScrollViewDelegate>
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) UIScrollView *pageScroll;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation GuidViewController

+ (GuidViewController *)sharedGuide
{
	@synchronized(self)
	{
		static GuidViewController *sharedGuide = nil;
		if (sharedGuide == nil)
		{
			sharedGuide = [[self alloc] init];
		}
		return sharedGuide;
	}
}

+ (void)show
{
	[[GuidViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[GuidViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[GuidViewController sharedGuide] hideGuide];
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[GuidViewController sharedGuide].view.frame = [self onscreenFrame];
		[[self mainWindow] addSubview:[GuidViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		//[UIView setAnimationDuration:0.4];
		[UIView setAnimationDuration:0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[GuidViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[GuidViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[GuidViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
	UIApplication *app = [UIApplication sharedApplication];
	if ([app.delegate respondsToSelector:@selector(window)])
	{
		return [app.delegate window];
	}
	else
	{
		return [app keyWindow];
	}
}

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.view.frame = [self onscreenFrame];
	
    [self.view addSubview:self.pageScroll];

//	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
//																   self.view.frame.size.height - 140,
//																   self.view.frame.size.width,
//																   10)];
//	_pageControl.userInteractionEnabled = NO;
//	[self.view addSubview:_pageControl];
	
	// imageView
	NSString *imgName = nil;
	UIImageView *view = nil;
	for (NSInteger i = 0; i < self.imageArray.count; i++)
	{
		imgName = [self.imageArray objectAtIndex:i];
		view = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i),
															  0.f,
															  self.view.frame.size.width,
															  self.view.frame.size.height)];
		[view setImage:[UIImage imageNamed:imgName]];
		view.userInteractionEnabled = YES;
		[self.pageScroll addSubview:view];
		
		if (i == self.imageArray.count - 1)
		{
			[self addEnterButton:view];
		}
	}
//	_pageControl.numberOfPages = self.imageArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addEnterButton:(UIView*)bgView
{
	CGRect frame = CGRectMake(self.view.frame.size.width*0.5-150,
							  self.view.frame.size.height - 170,
							  300,
							  75);
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundColor:[UIColor clearColor]];
	[button addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
	 button.frame = frame;
	[bgView addSubview:button];
}

- (void)pressEnterButton:(UIButton*)sender
{
	[self hideGuide];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_LAUNCHED];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//	NSInteger page = (self.pageScroll.contentOffset.x + self.view.bounds.size.width / 2.0) / self.view.bounds.size.width;
//	if (page!= _pageControl.currentPage)
//	{
//		_pageControl.currentPage = page;
//	}
}

-(UIScrollView *)pageScroll{
    if (!_pageScroll) {
        _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _pageScroll.pagingEnabled = YES;
        _pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * self.imageArray.count, self.view.frame.size.height);
        _pageScroll.showsHorizontalScrollIndicator = NO;
        _pageScroll.bounces = NO;
        _pageScroll.delegate = self;
    }
    return _pageScroll;
}
-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] initWithObjects:@"FirstTime_First",@"FirstTime_Second",@"FirstTime_Third", nil];
    }
    return _imageArray;
}
@end
