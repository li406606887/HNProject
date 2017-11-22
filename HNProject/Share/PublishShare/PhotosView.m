//
//  PhotosView.m
//  微博发图
//
//  Created by LLQ on 16/7/7.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "PhotosView.h"
#import <Photos/Photos.h>
#import "UIView+ViewController.h"
#import "PhotoModel.h"
#import "PublishShareViewModel.h"
#import "YFShowGroupAlbumVC.h"

#define kItemW SCREEN_WIDTH*0.3
#define kItemH SCREEN_WIDTH*0.3
#define kSpace 10

@interface PhotosView()
@end

@implementation PhotosView {
    UIButton *_addBtn;  //添加按钮
    NSInteger _selectIndex;
}


-(void)setupViews{
    //指定frame
    self.backgroundColor = RGB(244, 244, 250);
//    self.backgroundColor = [UIColor greenColor];
    //创建添加按钮
    [self createBtn];
    //判断是否授权
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        NSLog(@"相册访问受限");
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"pushImage" object:nil] subscribeNext:^(NSNotification *notification) {
        if (![notification.name isEqualToString:@"pushImage"]) {
            return ;
        }
        @strongify(self)
        NSDictionary *dic = (NSDictionary*)notification.object;
        NSMutableArray *array = [dic objectForKey:@"cellImage"];
        for (int i= 0; i< array.count; i++) {
            NSLog(@"%ld",array.count);
            UIImage *image = array[i];
            PhotoModel *model = [[PhotoModel alloc] init];
            model.image = image;
            model.index = i;
            [self.selectArray addObject:model];
        }
        [self createImgView];
    }];
    
}
-(void)updateConstraints{
    [super updateConstraints];
    
}
//复写init方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

//创建添加图片的btn
- (void)createBtn{
    //初始化
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, kItemW, kItemH)];
    [_addBtn setImage:[UIImage imageNamed:@"Share_Add_Photo"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
}

//按钮点击方法
- (void)addBtnAction:(UIButton *)btn{
    //推出相册视图
    YFShowGroupAlbumVC *pVC = [[YFShowGroupAlbumVC alloc] init];
    pVC.showAlbumStyle = ENUM_AllOfPhoto;
    pVC.albumColor = [UIColor blackColor];
    pVC.listCount =3;
    pVC.count = (int)self.selectArray.count;
    [self.viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:pVC] animated:YES completion:nil];
}


//创建九宫格图片视图
- (void)createImgView{
    @weakify(self)
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    long count = self.selectArray.count;
    int column;
    if ((int)count==9) {
        column =2;
    }else{
        column = (int)count/3;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset((column+1)*(kItemH +10)+10);
    }];
    //创建图片视图
    for (int i = 0; i < self.selectArray.count; i ++) {
        //创建图片视图
        UIImageView *item = [[UIImageView alloc] initWithFrame:[self makeFrameWithIndex:i]];
        PhotoModel *model = (PhotoModel *)self.selectArray[i];
        item.image = model.image;
        item.userInteractionEnabled = YES;
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete setImage:[UIImage imageNamed:@"Share_delete_image"] forState:UIControlStateNormal];
        delete.tag = (int)model.index;
        [item addSubview:delete];
        delete.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 0);
        [delete mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(item.mas_right);
            make.top.equalTo(item);
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
        [[delete rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"%d",(int)delete.tag);
            @strongify(self)
            [self.selectArray removeObject:model];
            [_itemArray removeAllObjects];
            [self createImgView];
            return ;
        }];
        //添加入子视图数组
        [self.itemArray addObject:item];
        [self addSubview:item];
    }
    //改变添加按钮的位置
    if (self.selectArray.count >= 9) {
        //将按钮隐藏
        _addBtn.hidden = YES;
    }else {
        //将按钮显示
        _addBtn.hidden = NO;
        [self moveAddBtn];
    }
}

//根据下标计算frame
- (CGRect)makeFrameWithIndex:(int)index {
    int x = ((index%3)+1)*kSpace + (index%3)*kItemW;
    int y = (index/3+1)*kSpace + (index/3)*kItemH;
    return CGRectMake(x, y, kItemW, kItemH);
}

//改变添加按钮位置方法
- (void)moveAddBtn {
    NSInteger index = self.selectArray.count;
    NSInteger x = ((index%3)+1)*kSpace + (index%3)*kItemW;
    NSInteger y = (index/3+1)*kSpace + (index/3)*kItemH;
    _addBtn.frame = CGRectMake(x, y, kItemW, kItemH);
//    CGFloat height = y+ kItemH;
//    if (index==9) {
//        
//    }
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
    
}


#pragma mark ------ 触摸事件

//触摸开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    //获取触摸点
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    
//    //当前点击到的图片的下标小于图片数组的元素个数
//    _selectIndex = [self itemIndexWithPoint:point];
//    if (_selectIndex < self.itemArray.count) {
//        UIImageView *item = self.itemArray[_selectIndex];
//        //拿到最上层
//        [self bringSubviewToFront:item];
//        //动画效果
//        [UIView animateWithDuration:0.3 animations:^{
//            //改变当前选中图片视图的大小和位置
//            item.center = point;
//            item.transform = CGAffineTransformMakeScale(1.2, 1.2);
//            item.alpha = 0.8;
//        }];
//    }
}

//触摸移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    //获取触摸点
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    //获取当前触摸点位置下标
//    NSInteger index = [self itemIndexWithPoint:point];
//
//    if (_selectIndex < self.itemArray.count) {
//        UIImageView *item = self.itemArray[_selectIndex];
//        item.center = point;
//        if (index < self.itemArray.count && index != _selectIndex) {
//            //当前点位置所属下标与选中下标不同
//            //将两个图片分别在数据源数组和子视图数组中移除
//            PhotoModel *model = self.selectArray[_selectIndex];
//            [self.selectArray removeObjectAtIndex:_selectIndex];
//            [self.itemArray removeObjectAtIndex:_selectIndex];
//            //重新插入到指定位置
//            [self.selectArray insertObject:model atIndex:index];
//            [self.itemArray insertObject:item atIndex:index];
//            //重新记录选中下标
//            _selectIndex = index;
//            //重新布局
//            [self restartMakeItemFram];
//        }
//    }
}

//触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (_selectIndex < _itemArray.count) {
//        UIImageView *item = _itemArray[_selectIndex];
//        //还原操作
//        [UIView animateWithDuration:0.3 animations:^{
//            item.transform = CGAffineTransformIdentity;
//            item.alpha = 1;
//            item.frame = [self makeFrameWithIndex:(int)_selectIndex];
//        }];
//    }
}

//通过点击的点返回当前点中的图片
- (NSInteger)itemIndexWithPoint:(CGPoint)point{
    for (int i = 0; i < self.itemArray.count; i ++) {
        //计算frame
        CGRect frame = [self makeFrameWithIndex:i];
        //判断当前点是否是frame范围的点
        if (CGRectContainsPoint(frame, point)) {
            return i;
        }
    }
    return 100;
}
//根据数据源数组重新布局
- (void)restartMakeItemFram{
    for (int i = 0; i < self.selectArray.count; i ++) {
        if (i != _selectIndex) {
            UIImageView *item = _itemArray[i];
            [UIView animateWithDuration:0.3 animations:^{
                item.frame = [self makeFrameWithIndex:i];
            }];
        }
    }
}

-(NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}

//itemArray的懒加载方法
- (NSMutableArray *)itemArray {
    if (_itemArray == nil) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}
@end
