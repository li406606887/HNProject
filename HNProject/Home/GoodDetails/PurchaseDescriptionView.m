//
//  PurchaseDescriptionView.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PurchaseDescriptionView.h"
#import "GoodDetailsViewModel.h"

@interface PurchaseDescriptionView()<UIWebViewDelegate>
@property(nonatomic,strong) GoodDetailsViewModel *viewModel;
@property(nonatomic,strong) UIImageView *blackLine;
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UIButton  *downArrow;
@property(nonatomic,strong) UIWebView *webView;
@end

@implementation PurchaseDescriptionView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (GoodDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.blackLine];
    [self addSubview:self.title];
    [self addSubview:self.lineView];
    [self addSubview:self.downArrow];
    [self addSubview:self.webView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}
-(void)updateConstraints{
    [super updateConstraints];
    
    [self.blackLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).with.offset(6);
        make.size.mas_offset(CGSizeMake(3, 14));
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.top.equalTo(self).with.offset(6);
        make.size.mas_offset(CGSizeMake(100, 15));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(30);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-40, 1));
    }];
    [self.downArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(30, 0, 0, 0));
    }];
}
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL{
    
}
-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.refreshUISubject subscribeNext:^(GoodDetailsModel*  _Nullable model) {
        @strongify(self)
        [self.webView loadHTMLString:model.content baseURL:[NSURL URLWithString:HostUrlBak]];
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIImageView *)blackLine{
    if (!_blackLine) {
        _blackLine = [[UIImageView alloc] init];
        _blackLine.image = [UIImage imageNamed:@"Home_Good_Details_Black_Line"];
    }
    return _blackLine;
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"购买描述";
        _title.font = [UIFont systemFontOfSize:17];
    }
    return _title;
}
-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(244, 244, 244);
    }
    return _lineView;
}
-(UIButton *)downArrow{
    if (!_downArrow) {
        _downArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downArrow setImage:[UIImage imageNamed:@"Home_Good_Down_Arrow"] forState:UIControlStateNormal];
        @weakify(self)
        [[_downArrow rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self)
            _downArrow.selected = !_downArrow.selected;
            if (_downArrow.selected == YES) {
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(100);
                }];
            }else{
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                }];
                [self.viewModel.scrollContentSizeSubject sendNext:@"30"];
            }
            
        }];
    }
    return _downArrow;
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
       
        _webView.delegate = self;
 
    }
    return _webView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGRect frame = self.webView.frame;
        
        frame.size = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
        
        self.webView.frame = frame;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(frame.size.height+30);
        }];
        NSString *height = [NSString stringWithFormat:@"%f",frame.size.height+30];
        [self.viewModel.scrollContentSizeSubject sendNext:height];
    }
    
}
-(void)dealloc{
    [self.webView.scrollView removeObserver:self
                                         forKeyPath:@"contentSize" context:nil];
}
@end
