//
//  InviteFriendsCell.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "InviteFriendsCell.h"


@implementation InviteFriendsCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}
-(void)setupViews{
    self.textLabel.font = [UIFont systemFontOfSize:13];
    NSDictionary *dic =@{NSForegroundColorAttributeName:RGB(155, 155, 155),NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"已经完成购买0次" attributes:dic];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(6, 1)];
    self.detailTextLabel.attributedText = att;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(void)updateConstraints{
    [super updateConstraints];
}
-(void)setModel:(InviteFriendsModel *)model{
    if (model) {
        self.textLabel.text = [NSString stringWithFormat:@"%@",model.real_name];
        if (model.count.length>0) {
             NSDictionary *dic =@{NSForegroundColorAttributeName:RGB(155, 155, 155),NSFontAttributeName:[UIFont systemFontOfSize:13]};
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已经完成购买%@次",model.count] attributes:dic];
            [attributed addAttribute:NSForegroundColorAttributeName value:RGB(40, 40, 40) range:NSMakeRange(6, model.count.length)];
            self.detailTextLabel.attributedText = attributed;
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
