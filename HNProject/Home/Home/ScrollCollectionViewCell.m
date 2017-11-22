
//
//  ScrollCollectionViewCell.m
//  RDFuturesApp
//
//  Created by user on 17/4/13.
//  Copyright © 2017年 FuturesApp. All rights reserved.
//

#import "ScrollCollectionViewCell.h"

@interface ScrollCollectionViewCell()
@property(nonatomic,strong)UIImageView *image;
@end


@implementation ScrollCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.image];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

-(void)setImage_url:(NSString *)image_url {
    [self.image sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"loading_image_loading"]];
}

-(UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image;
}

-(void)updateConstraints {
    @weakify(self)
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

@end
