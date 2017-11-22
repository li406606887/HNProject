//
//  HistoryShareView.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HistoryShareView.h"
#import "HistoryShareViewModel.h"
#import "HistoryShareCollectionViewCell.h"


@interface HistoryShareView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) HistoryShareViewModel *viewModel;
@property(nonatomic,strong) UICollectionView *collectionView;
@end

@implementation HistoryShareView

-(instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    self.viewModel = (HistoryShareViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}
-(void)setupViews{
    [self addSubview:self.collectionView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)bindViewModel{
    @weakify(self)
    [self.viewModel.getHistoryCommand execute:nil];
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView reloadData];
        switch ([x integerValue]) {
            case HeaderRefresh_HasMoreData:
                [self.collectionView.mj_header endRefreshing];
                break;
            case HeaderRefresh_HasNoMoreData:
                [self.collectionView.mj_header endRefreshing];
                self.collectionView.mj_footer = nil;
                break;
                
            case FooterRefresh_HasMoreData:
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer resetNoMoreData];
                [self.collectionView.mj_footer endRefreshing];
                break;
                
            case FooterRefresh_HasNoMoreData:
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                break;
                
            case RefreshError:
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView.mj_header endRefreshing];
                break;
                
            default:
                break;
        }

    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([HistoryShareCollectionViewCell class])] forIndexPath:indexPath];
    cell.model = self.viewModel.dataArray[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH *0.5-15, SCREEN_WIDTH*0.5+55);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.viewModel.cellClickSubject sendNext:self.viewModel.dataArray[indexPath.row]];
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
        _collectionView.backgroundColor = DEFAULT_BG_COLOR;
        [_collectionView registerClass:[HistoryShareCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([HistoryShareCollectionViewCell class])]];
        @weakify(self)
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.getHistoryCommand execute:@"0"];
        }];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.viewModel.getHistoryCommand execute:nil];
        }];
    }
    return _collectionView;
}
@end
