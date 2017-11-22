//
//  SumbitImageView.m
//  HNProject
//
//  Created by user on 2017/7/28.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "SumbitImageView.h"
#import "PhotosView.h"
#import "SumbitImageViewModel.h"

@interface SumbitImageView ()
@property(nonatomic,strong) PhotosView *photo;
@property(nonatomic,strong) SumbitImageViewModel *viewModel;
@property(nonatomic,strong) NSMutableArray *keyArray;
@property(nonatomic,strong) UILabel *wangwanglabel;//旺旺号
@property(nonatomic,strong) UITextField *wangwangField;
@property(nonatomic,strong) UILabel *orderLabel;//订单号
@property(nonatomic,strong) UITextField *orderField;
@end

@implementation SumbitImageView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (SumbitImageViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews {
    [self addSubview:self.wangwanglabel];
    [self addSubview:self.wangwangField];
    [self addSubview:self.orderLabel];
    [self addSubview:self.orderField];
    [self addSubview:self.photo];
    self.backgroundColor = [UIColor whiteColor];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    
    [self.wangwanglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    [self.wangwangField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wangwanglabel);
        make.left.equalTo(self.wangwanglabel.mas_right).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-80, 30));
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wangwanglabel.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    
    [self.orderField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderLabel);
        make.left.equalTo(self.orderLabel.mas_right).with.offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-80, 30));
    }];
    
    [self.photo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*0.3+20));
    }];
}

-(void)bindViewModel{
   
    @weakify(self)
    [[self.viewModel.sendSumbitSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.wangwangField.text.length<1) {
            showMassage(@"请输入您的旺旺号")
            return ;
        }
        if (self.orderField.text.length<1) {
            showMassage(@"请输入您的订单号")
            return ;
        }
        if (self.photo.itemArray.count < 1) {
            showMassage(@"请选择要上传的图片");
            return ;
        }
        NSArray *imageArray = self.photo.itemArray;
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
    if (self.keyArray.count<1) {
        showMassage(@"请选择需要上传的图片")
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.keyArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *fileString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.viewModel.projectID forKey:@"id"];
    [param setObject:fileString forKey:@"thumb"];
    [param setObject:self.wangwangField.text forKey:@"wangwang_id"];
    [param setObject:self.orderField.text forKey:@"order_id"];
    [self.viewModel.sendSumbitCommand execute:param];
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

-(PhotosView *)photo{
    if (!_photo) {
        _photo = [[PhotosView alloc] initWithViewModel:self.viewModel];
    }
    return _photo;
}

-(UILabel *)wangwanglabel {
    if (!_wangwanglabel) {
        _wangwanglabel = [[UILabel alloc] init];
        _wangwanglabel.font = [UIFont systemFontOfSize:14];
        _wangwanglabel.text = @"旺旺号";
    }
    return _wangwanglabel;
}

-(UITextField *)wangwangField {
    if (!_wangwangField) {
        _wangwangField = [[UITextField alloc] init];
        _wangwangField.placeholder = @"请输入旺旺号";
        _wangwangField.font = [UIFont systemFontOfSize:14];
        _wangwangField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
        _wangwangField.leftViewMode = UITextFieldViewModeAlways;
        _wangwangField.layer.masksToBounds = YES;
        _wangwangField.layer.cornerRadius = 3;
        _wangwangField.layer.borderWidth = 0.5;
        _wangwangField.layer.borderColor = RGB(232, 232, 232).CGColor;
    }
    return _wangwangField;
}

-(UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.font = [UIFont systemFontOfSize:14];
        _orderLabel.text = @"订单号";
    }
    return _orderLabel;
}

-(UITextField *)orderField {
    if (!_orderField) {
        _orderField = [[UITextField alloc] init];
        _orderField.placeholder = @"请输入订单号";
        _orderField.font = [UIFont systemFontOfSize:14];
        _orderField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
        _orderField.leftViewMode = UITextFieldViewModeAlways;
        _orderField.layer.masksToBounds = YES;
        _orderField.layer.cornerRadius = 3;
        _orderField.layer.borderWidth = 0.5;
        _orderField.layer.borderColor = RGB(232, 232, 232).CGColor;
    }
    return _orderField;
}

-(NSMutableArray *)keyArray{
    if (!_keyArray) {
        _keyArray = [[NSMutableArray alloc] init];
    }
    return _keyArray;
}
@end
