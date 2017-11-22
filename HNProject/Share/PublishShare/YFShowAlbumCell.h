//
//  ShowCell.h
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFShowAlbumCell : UICollectionViewCell
//图片
@property (strong, nonatomic)  UIImageView *imageView;
//按钮
@property (strong, nonatomic)  UIButton *selectBtn;
//显示的按钮
@property (strong, nonatomic)  UIButton *clickBtn;

//按钮选定
@property(nonatomic,copy)void(^selectedBlock)(NSInteger index);
//取消选定
@property(nonatomic,copy)void(^cancelBlock)(NSInteger index);


@end
