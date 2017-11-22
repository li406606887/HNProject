//
//  PersonalInfoViewController.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalInfoView.h"
#import "PersonalInfoViewModel.h"
#import "IndividualitySignatureController.h"


@interface PersonalInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) PersonalInfoView *personalInfoView;
@property(nonatomic,strong) PersonalInfoViewModel *viewModel;
@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel.getUserInfoCommand execute:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addChildView{
    [self.view addSubview:self.personalInfoView];
}
-(void)updateViewConstraints {
    [super updateViewConstraints];
    [self.personalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)bindViewModel{
    @weakify(self)
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        switch ([x intValue]) {
            case 0:
                [self chooseHeadImage];
                break;
            case 6: {
                IndividualitySignatureController *indiv = [[IndividualitySignatureController alloc] init];
                [self.navigationController pushViewController:indiv animated:YES];
            }
                break;
                
            default:
                break;
        }
    }];
}

-(void)chooseHeadImage {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancle setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    [camera setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction * picture = [UIAlertAction actionWithTitle:@"相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController * pickerImage = [[UIImagePickerController alloc]init];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        
        [self presentViewController:pickerImage animated:YES completion:nil];
    }];
    [picture setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    [alert addAction:cancle];
    [alert addAction:picture];
    [alert addAction:camera];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 相机代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //  获取
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.mainView.headImage  = image;
//        [self.mainView.tableView reloadData];
    });
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    //更新
    [self uploadHeadImgViewWithImage:image andQiniuToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"QNToken"]];
    
}
#pragma mark - 上传七牛
-(void)uploadHeadImgViewWithImage:(UIImage *)image andQiniuToken:(NSString *)token {
    //上传7niu
    loading(@"正在上传")
    QNUploadManager *upManager = [[QNUploadManager alloc]init];
    NSData * jpgData = UIImageJPEGRepresentation(image, 0.3f);
    NSString * key = [self arc4randomForKey];
    
    [upManager putData:jpgData key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        hiddenHUD;
        NSLog(@"info=%dresp=%@",info.statusCode,resp);
        if (info.statusCode == 200) {
            showMassage(@"头像上传成功")
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:key forKey:@"avatar"];
            [self.viewModel.updateUserInfoCommand execute:param];
            [self.personalInfoView.table reloadData];
        }else showMassage(@"头像上传失败")
            } option:nil];
    
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
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(PersonalInfoView *)personalInfoView{
    if (!_personalInfoView) {
        _personalInfoView = [[PersonalInfoView alloc] initWithViewModel:self.viewModel];
    }
    return _personalInfoView;
}
-(PersonalInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PersonalInfoViewModel alloc] init];
    }
    return _viewModel;
}
@end
