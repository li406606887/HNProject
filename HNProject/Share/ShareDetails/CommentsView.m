//
//  CommentsView.m
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "CommentsView.h"
#import "ShareDetailsViewModel.h"

@interface CommentsView ()
@property(nonatomic,strong) ShareDetailsViewModel *viewModel;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIButton *sender;
@property(nonatomic,copy  ) NSString *str;
@end

@implementation CommentsView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (ShareDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.backView];
    [self addSubview:self.commentField];
    [self addSubview:self.sender];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.commentField becomeFirstResponder];
    });
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.sender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentField.mas_right);
        make.bottom.equalTo(self.commentField.mas_bottom);
        make.size.mas_offset(CGSizeMake(50, 40));
    }];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UITextField *)commentField{
    if (!_commentField) {
        _commentField = [[UITextField alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-104, SCREEN_WIDTH-50, 40)];
        _commentField.backgroundColor = [UIColor whiteColor];
        _commentField.placeholder = @"评论";
        _commentField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
        _commentField.leftView.userInteractionEnabled = NO;
        _commentField.leftViewMode = UITextFieldViewModeAlways;
        _commentField.userInteractionEnabled = YES;
        @weakify(self)
        [_commentField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            if (_commentField.text.length<1) {
                self.sender.backgroundColor = RGB(200, 200, 200);
                self.sender.userInteractionEnabled = NO;
            }else {
                self.sender.backgroundColor = DEFAULT_COLOR;
                self.sender.userInteractionEnabled = YES;
            }
        }];
    }
    return _commentField;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.3;
    }
    return _backView;
}
-(UIButton *)sender {
    if (!_sender) {
        _sender = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sender setTitle:@"评论" forState:UIControlStateNormal];
        [_sender.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sender setBackgroundColor:DEFAULT_COLOR];
        [_sender setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        @weakify(self)
        [[_sender rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
            [param setObject:self.commentField.text forKey:@"content"];
            [self.viewModel.sendCommentsCommand execute:param];
            [self removeFromSuperview];
        }];
    }
    return _sender;
}
@end
