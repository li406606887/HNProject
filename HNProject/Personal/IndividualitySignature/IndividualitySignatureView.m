//
//  IndividualitySignatureView.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "IndividualitySignatureView.h"
#import "IndividualitySignatureViewModel.h"

@interface IndividualitySignatureView()<UITextViewDelegate>
@property(nonatomic,strong) IndividualitySignatureViewModel *viewModel;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) UILabel *prompt;

@end

@implementation IndividualitySignatureView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (IndividualitySignatureViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews{
    [self addSubview:self.backView];
    [self.backView addSubview:self.textView];
    [self.backView addSubview:self.prompt];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    [super updateConstraints];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(15);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 60));
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.backView);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 60));
    }];
    [self.prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).with.offset(-8);
        make.bottom.equalTo(self.backView.mas_bottom).with.offset(-3);
        make.size.mas_offset(CGSizeMake(30, 20));
    }];
}

-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.sumbitClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:self.textView.text forKey:@"motto"];
        [self.viewModel.saveSignatureCommand execute:param];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:14];
        @weakify(self)
        _textView.text = [HNUesrInformation getInformation].model.motto;
        [_textView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
           @strongify(self)
            NSLog(@"%@",_textView.text);
            if (_textView.text.length >= 15) {
                _textView.text = [_textView.text substringToIndex:15];
            }
            self.prompt.text = [NSString stringWithFormat:@"%d",(int)(15-_textView.text.length)];
        }];
    }
    return _textView;
}
-(UILabel *)prompt {
    if (!_prompt) {
        _prompt = [[UILabel alloc] init];
        _prompt.text = @"15";
        _prompt.textColor = RGB(158, 158, 158);
        _prompt.font = [UIFont systemFontOfSize:14];
        _prompt.textAlignment = NSTextAlignmentRight;
    }
    return _prompt;
}
-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [_backView setBackgroundColor:[UIColor whiteColor]];
    }
    return _backView;
}
@end
