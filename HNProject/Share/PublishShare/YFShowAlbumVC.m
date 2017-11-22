//
//  ShowViewController.m
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "YFShowAlbumVC.h"
#import "YFShowAlbumCell.h"
#import "YFSelfImage.h"
#import "NSObject+YFPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+YF.h"

static NSString * const SHOWCELL = @"YFShowAlbumCell";
@interface YFShowAlbumVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    //右边的按钮
}
@property(nonatomic,strong)UICollectionView *collectionView;
//所有需要显示的图片
@property(nonatomic,strong)NSMutableArray *dataArray;
//选中的坐标
@property(nonatomic,strong)NSMutableArray *selectedArray;
//选中的图片
@property(nonatomic,strong)NSMutableDictionary *selectedDictionary;
@end

@implementation YFShowAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    //自定义导航栏按钮
    [self setItemBtn];
    
    //多少照片
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library callAllPhoto:_group result:^(YFSelfImage *image) {
        [self.dataArray addObject:image];
    }];
    //加载
    [self initCollectionView];

}
/**
 *  加载九宫格
 */
- (void)initCollectionView{

    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:[self setFlowOut]];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    if (_color) {
        _collectionView.backgroundColor = _color;
    }
    
    [_collectionView registerClass:[YFShowAlbumCell class] forCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([YFShowAlbumCell class])]];
    [self.view addSubview:_collectionView];
}
/**
 *  自定义导航栏按钮
 */
- (void)setItemBtn{
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    selectBtn.frame = CGRectMake(0, 0, 50, 30);
    [selectBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(successChoose) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:selectBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
/**
 *  完成选定
 */
- (void)successChoose{
    if (self.selectedArray.count<1) {
        showMassage(@"您还未选择要上传的照片");
        return;
    }
    //把选择的图片传送过去
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i=0; i<self.selectedArray.count; i++) {
        YFSelfImage *imageALAssets = self.selectedArray[i];
        UIImage *image = [self fullResolutionImageFromALAsset:imageALAssets.asset];
        [imageArray addObject:image];
    }
    
    NSDictionary *dic = @{@"cellImage":imageArray};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushImage" object:dic];
    //退出模态
    [self dismissViewControllerAnimated:YES completion:^{
        //这一步确保退出到显示界面的时候显示相册组控制器一定退出
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
/**
 *  格式
 *
 *  @return <#return value description#>
 */
- (UICollectionViewFlowLayout *)setFlowOut{

    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    NSInteger rowCount = 4;
    if (_listCount && _listCount > 0) {
        rowCount = _listCount;
    }
    layOut.itemSize = CGSizeMake(self.view.frame.size.width / rowCount, self.view.frame.size.width / rowCount);
    layOut.minimumLineSpacing = 0;
    layOut.minimumInteritemSpacing = 0;
    return layOut;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (_showStyle == ENUM_Camera) {
        return self.dataArray.count + 1;
        
    }else{
       return self.dataArray.count;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    YFShowAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([YFShowAlbumCell class])] forIndexPath:indexPath];
    YFSelfImage *image = [_dataArray objectAtIndex:indexPath.row];
    cell.imageView.image = image;
    if([self.selectedDictionary objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]]){
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}
/**
 *  选择
 *
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(![self.selectedDictionary objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]]){
        if (self.selectedArray.count +self.count == 9) {
            showMassage(@"已达到最大上传数量");
            return;
        }else {
             [self.selectedDictionary setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [self.selectedArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
        }
    }else {
         [self.selectedDictionary removeObjectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        YFSelfImage *oldImage = [self.dataArray objectAtIndex:indexPath.row];
        for (YFSelfImage *newImage in self.selectedArray) {
            if (newImage == oldImage) {
                [self.selectedArray removeObject:newImage];
            }
        }
    }
    [self.collectionView reloadData];
}
#pragma mark  相机代理
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //    //图片
    UIImage *image;
    //判断是不是从相机过来的
    if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {
        //关闭相机
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    //通过判断picker的sourceType，如果是拍照则保存到相册去.非常重要的一步，不然，无法获取照相的图片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
/**
 *  确定相机图片保存到系统相册后，进行图片获取
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
    //操作获得的照片，我这是直接显示，你那个你加到你显示的一组里面去显示去就好了
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    
    //操作获得的照片，我这是直接显示，你那个你加到你显示的一组里面去显示去就好了
    [library afterCameraAsset:^(ALAsset *asset) {
        YFSelfImage *image = [[YFSelfImage alloc]initWithCGImage:asset.thumbnail];
        image.asset = asset;
        //传递
        NSDictionary *dic = @{@"saveImage":image};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SAVEIMAGE" object:nil userInfo:dic];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
}

-(NSMutableDictionary *)selectedDictionary {
    if (!_selectedDictionary) {
        _selectedDictionary = [[NSMutableDictionary alloc] init];
    }
    return _selectedDictionary;
}
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}
-(UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}
@end
