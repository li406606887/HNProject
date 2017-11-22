//
//  ViewController.m
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "YFShowGroupAlbumVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YFShowAlbumVC.h"
#import "ALAssetsLibrary+YF.h"
#import "PhotoGroupTableViewCell.h"

@interface YFShowGroupAlbumVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) ALAssetsLibrary *library;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation YFShowGroupAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相 册";
    //左侧返回按钮
    [self leftItemBtn];
    [self.view addSubview:self.tableView];
    MJWeakSelf
    [self.library countOfAlbumGroup:^(ALAssetsGroup *yfGroup) {
        [weakSelf.dataArray addObject:yfGroup];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark 返回按钮设置事件
/**
 *  设置左边返回按钮
 */
- (void)leftItemBtn{
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [returnBtn setTitle:@"取 消" forState:UIControlStateNormal];
    returnBtn.frame = CGRectMake(0, 0, 40, 30);
    [returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc]initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem = itemBtn;
}
//返回按钮
- (void)clickReturnBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
}

#pragma mark 表的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * const ID = @"cell";
    PhotoGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PhotoGroupTableViewCell alloc]initWithStyle:0 reuseIdentifier:ID];
        cell.imageView.frame =CGRectMake(10, 10, 80, 80);
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ALAssetsGroup *group = (ALAssetsGroup *)[self.dataArray objectAtIndex:indexPath.row];
    if (group) {
        //相册第一张图片
        cell.groupIcon.image = [UIImage imageWithCGImage:group.posterImage];
        //相册名字
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        if ([groupName isEqualToString:@"Camera Roll"]) {
            groupName = @"我的相册";
        }
        cell.label.text = [NSString stringWithFormat:@"%@(%ld)",groupName,(long)[group numberOfAssets]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转
    YFShowAlbumVC *show = [[YFShowAlbumVC alloc]init];
    ALAssetsGroup *group = (ALAssetsGroup *)[self.dataArray objectAtIndex:indexPath.row];
    show.group = group;
    show.listCount = self.listCount;
    show.color = self.albumColor;
    show.showStyle = self.showAlbumStyle;
    show.count = self.count;
    [self.navigationController pushViewController:show animated:YES];
}


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
//        _tableView.backgroundColor = [UIColor blackColor];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(ALAssetsLibrary *)library {
    if (!_library) {
        _library = [[ALAssetsLibrary alloc]init];
    }
    return _library;
}
@end
