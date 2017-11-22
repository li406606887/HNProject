//
//  GrabCouponView.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "GrabCouponView.h"
#import "GrabCouponViewModel.h"
#import "HomeHeadView.h"
#import "HomeCollectionViewCell.h"


@interface GrabCouponView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) GrabCouponViewModel *viewModel;
@property(nonatomic,strong) HomeHeadView *headView;
@property(nonatomic,strong) UICollectionView *collectionView;
@end
@implementation GrabCouponView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (GrabCouponViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)setupViews {
    [self addSubview:self.collectionView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    [super updateConstraints];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)bindViewModel {
    @weakify(self)
    [self.viewModel.getCollectionDataCommand execute:nil];
    [self.viewModel.getBannerDataCommand execute:nil];
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView reloadData];
        switch ([x integerValue]) {
            case RefreshError:
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView.mj_header endRefreshing];
                break;
            default:
                break;
        }
    }];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*0.5+50);
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView* reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeCollectionViewHead" forIndexPath:indexPath];
    [reusableView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(reusableView);
    }];
    reusableView.backgroundColor = [UIColor whiteColor];
    return reusableView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.collectionArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([HomeCollectionViewCell class])] forIndexPath:indexPath];
    cell.model = self.viewModel.collectionArray[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH *0.5-15, SCREEN_WIDTH*0.5+95);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel.detailsCellClickSubject sendNext:self.viewModel.collectionArray[indexPath.row]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([HomeCollectionViewCell class])]];
         [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeCollectionViewHead"];
        @weakify(self)
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.getBannerDataCommand execute:nil];
        }];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.getCollectionDataCommand execute:nil];
        }];
    }
    return _collectionView;
}

-(HomeHeadView *)headView {
    if (!_headView) {
        _headView = [[HomeHeadView alloc] initWithViewModel:self.viewModel];
    }
    return _headView;
}
@end
