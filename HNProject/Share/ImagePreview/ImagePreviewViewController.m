//
//  ImagePreviewViewController.m
//  HNProject
//
//  Created by user on 2017/8/9.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ImagePreviewViewController.h"

@interface ImagePreviewViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *scroll;
@property(nonatomic,assign) CGFloat contentWidth;
@end

@implementation ImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"图片预览"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setImageArray:(NSArray *)imageArray {
    if (imageArray) {
        self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH * imageArray.count, 0.5);
        for (int i = 0; i<imageArray.count; i++) {
            UIImageView *image = [[UIImageView alloc] init];
            [image sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@""]];
            image.contentMode = UIViewContentModeScaleAspectFit;
            [self.scroll addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.scroll);
                make.left.equalTo(self.scroll).with.offset(SCREEN_WIDTH*i);
                make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
            }];
            self.contentWidth = self.contentWidth + image.image.size.width;
        }
        [self.scroll setContentSize:CGSizeMake(SCREEN_WIDTH*imageArray.count, 0.5f)];
    }
}
-(void)addChildView {
    [self.view addSubview:self.scroll];
    
}
-(void)updateViewConstraints {
    [super updateViewConstraints];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(CGFloat)contentWidth {
    if (!_contentWidth) {
        _contentWidth = 0;
    }
    return _contentWidth;
}
-(UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] init];
        _scroll.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _scroll.delegate = self;
        _scroll.bounces = NO;
        _scroll.pagingEnabled = YES;
    }
    return _scroll;
}
@end
