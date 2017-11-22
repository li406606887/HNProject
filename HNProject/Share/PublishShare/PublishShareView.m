//
//  PublishShareView.m
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PublishShareView.h"
#import "PublishShareViewModel.h"
#import "PhotosView.h"

@interface PublishShareView ()
@property(nonatomic,strong) PublishShareViewModel *viewModel;
@property(nonatomic,strong) PhotosView *photoView;
@property(nonatomic,strong) UITextField *titleView;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UILabel *placeHolderLabel;
@property(nonatomic,strong) UITextView *contentView;
@property(nonatomic,strong) UIButton *prompt;
@property(nonatomic,strong) NSMutableArray *keyArray;
@end

@implementation PublishShareView
-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (PublishShareViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.photoView];
    [self addSubview:self.titleView];
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.contentView];
    [self.contentView addSubview:self.placeHolderLabel];
    [self addSubview:self.prompt];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*0.3+20));
    }];
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.photoView.mas_bottom).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 40));
    }];
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom).with.offset(1);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 150));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(6);
        make.top.equalTo(self.contentView).with.offset(6);
        make.size.mas_offset(CGSizeMake(100, 20));
    }];
    [self.prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.contentView.mas_bottom).with.offset(10);
        make.size.mas_offset(CGSizeMake(140, 30));
    }];
}

-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.publishShareSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.viewModel.shareTitle.length < 1) {
            showMassage(@"请输入分享标题");
            return ;
        }
        if (self.viewModel.shareContent.length < 1) {
            showMassage(@"请输入分享内容");
            return ;
        }
        if (self.photoView.itemArray.count < 1) {
            showMassage(@"请选择要上传的图片");
            return ;
        }
        NSArray *imageArray = self.photoView.itemArray;
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"QNToken"];
        loading(@"正在上传")
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i<imageArray.count; i++) {
            UIImageView*image = imageArray[i];
            [self uploadHeadImgViewWithImage:image.image andQiniuToken:token];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (i+1 == imageArray.count) {
                    [self sendSharesContent];
                    hiddenHUD;
                    return ;
                }
            });
        }
        });
        
    }];
    
}
-(void)sendSharesContent{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.keyArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *fileString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
    [param setObject:self.viewModel.shareTitle forKey:@"title"];
    [param setObject:self.viewModel.shareContent forKey:@"content"];
    [param setObject:fileString forKey:@"thumb"];
    [self.viewModel.publishShareCommand execute:param];
    [self.keyArray removeAllObjects];
}
#pragma mark - 上传七牛
-(void)uploadHeadImgViewWithImage:(UIImage *)image andQiniuToken:(NSString *)token {
    //上传7niu
    QNUploadManager *upManager = [[QNUploadManager alloc]init];
    NSData * jpgData = UIImageJPEGRepresentation(image, 0.3f);
    NSString * key = [self arc4randomForKey];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    @weakify(self)
    [upManager putData:jpgData key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        @strongify(self)
        if (info.statusCode == 200) {
            [self.keyArray addObject:key];
            dispatch_semaphore_signal(semaphore);
        }
    } option:nil];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

}
- (NSString *)arc4randomForKey {
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(PhotosView *)photoView{
    if (!_photoView) {
        _photoView = [[PhotosView alloc] initWithViewModel:self.viewModel];
    }
    return _photoView;
}

-(UITextField *)titleView{
    if (!_titleView) {
        _titleView = [[UITextField alloc] init];
        _titleView.placeholder = @"请输入编辑标题";
        _titleView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
        _titleView.leftView.userInteractionEnabled = NO;
        _titleView.leftViewMode = UITextFieldViewModeAlways;
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.font = [UIFont systemFontOfSize:14];
        @weakify(self)
        [[_titleView rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            self.viewModel.shareTitle = x;
        }];
    }
    return _titleView;
}

-(UITextView *)contentView{
    if (!_contentView) {
        _contentView = [[UITextView alloc] init];
        @weakify(self)
        [[_contentView rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            if (_contentView.text.length<1) {
                self.placeHolderLabel.alpha = 1;
            }else{
                self.placeHolderLabel.alpha = 0;
            }
            self.viewModel.shareContent = x;
        }];
    }
    return _contentView;
}

-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.text = @"编辑内容";
        _placeHolderLabel.textColor = RGB(200, 200, 200);
        _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    }
    return _placeHolderLabel;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
-(NSMutableArray *)keyArray {
    if (!_keyArray) {
        _keyArray = [[NSMutableArray alloc] init];
    }
    return _keyArray;
}
-(UIButton *)prompt {
    if (!_prompt) {
        _prompt = [[UIButton alloc] init];
        [_prompt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_prompt setTitle:@"《发表内容注意事项》" forState:UIControlStateNormal];
        [_prompt.titleLabel setFont:[UIFont systemFontOfSize:12]];
        @weakify(self)
        [[_prompt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.viewModel.readPromptSubject sendNext:nil];
        }];
    }
    return _prompt;
}
@end
