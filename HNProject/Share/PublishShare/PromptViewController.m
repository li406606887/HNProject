//
//  PromptViewController.m
//  HNProject
//
//  Created by user on 2017/9/11.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PromptViewController.h"

@interface PromptViewController ()
@property(nonatomic,strong) UILabel *prompt;
@end

@implementation PromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享提示";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildView {
    [self.view addSubview:self.prompt];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UILabel *)prompt {
    if (!_prompt) {
        _prompt = [[UILabel alloc] init];
        NSString *text = @"我们会在您发布成功后，后台工作人员会对您发布的内容进行审核，内容不可以出现如下违规操作\n用户不得冒充他人；不得利用他人的名义发布任何信息；不得恶意使用注册帐号导致其他用户误认； 任何机构或个人发布分享内容，不得有下列情形：\n（一）违反宪法或法律法规规定的；\n（二）危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n（三）损害国家荣誉和利益的，损害公共利益的；\n（四）煽动民族仇恨、民族歧视，破坏民族团结的；\n（五）破坏国家宗教政策，宣扬邪教和封建迷信的；\n（六）散布谣言，扰乱社会秩序，破坏社会稳定的；\n（七）散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n（八）侮辱或者诽谤他人，侵害他人合法权益的；\n（九）含有法律、行政法规禁止的其他内容的。\n";
        _prompt.numberOfLines = 0;
        _prompt.font = [UIFont systemFontOfSize:13];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
        CGSize attSize = [att boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        NSLog(@"%f",attSize.height);
        _prompt.attributedText = att;
        _prompt.frame = CGRectMake(20, 20, SCREEN_WIDTH-40, attSize.height);

    }
    return _prompt;
}
@end
