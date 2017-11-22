//
//  ShowCell.m
//  多选Demo
//
//  Created by 孙云 on 16/5/12.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "YFShowAlbumCell.h"

@implementation YFShowAlbumCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.clickBtn];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

-(void)updateConstraints {
    [super updateConstraints];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
}

//-(void)setSelected:(BOOL)selected{
//    self.selectBtn.selected = selected;
//}
/**
 *  按钮事件
 *
 *  @param sender <#sender description#>
 */
- (void)clickBtn:(UIButton *)sender {
    if(!sender.selected) {
        if (self.selectedBlock) {
            self.selectedBlock(sender.tag);
        }
        //做个小动画
        CABasicAnimation *anima = [CABasicAnimation animation];
        anima.keyPath = @"transform.scale";
        anima.toValue = @(1.3);
        anima.duration = 0.3;
        [sender.layer addAnimation:anima forKey:nil];
    }else {
        if (self.cancelBlock) {
            self.cancelBlock(sender.tag);
        }
    }
    sender.selected = !sender.selected;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
-(UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:nil forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"Share_Add_Image_Choose"] forState:UIControlStateSelected];
//        [_selectBtn addTarget:self
//                       action:@selector(clickBtn:)
//             forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
@end
