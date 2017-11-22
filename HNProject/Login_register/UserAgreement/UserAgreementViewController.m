//
//  UserAgreementViewController.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()
@property(nonatomic,strong) UILabel *textBody;
@property(nonatomic,strong) UIScrollView *scrollView;
@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"用户协议"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addChildView {
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UILabel *)textBody {
    if (!_textBody) {
        _textBody = [[UILabel alloc] init];
        _textBody.numberOfLines = 0;
        NSString *string = [NSString stringWithFormat:@"1、用户协议属于合同性质,其中条款属于按照合同法的要求在协议中的必要内容,不属于侵权。\n2、用户须保证注册信息的真实性、合法性、有效性承担全部责任，用户不得冒充他人；不得利用他人的名义发布任何信息；不得恶意使用注册帐号导致其他用户误认； 任何机构或个人注册和使用的互联网用户账号名称，不得有下列情形：\n（一）违反宪法或法律法规规定的；\n（二）危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n（三）损害国家荣誉和利益的，损害公共利益的；\n（四）煽动民族仇恨、民族歧视，破坏民族团结的；\n（五）破坏国家宗教政策，宣扬邪教和封建迷信的；\n（六）散布谣言，扰乱社会秩序，破坏社会稳定的；\n（七）散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n（八）侮辱或者诽谤他人，侵害他人合法权益的；\n（九）含有法律、行政法规禁止的其他内容的。\n3、依《合同法》规定,合同的条件包括：\n\n第十二条 合同的内容由当事人约定,一般包括以下条款:\n（一）当事人的名称或者姓名和住所;\n（二）标的;\n（三）数量;\n（四）质量;\n（五）价款或者报酬;\n（六）履行期限、地点和方式;\n（七）违约责任;\n（八）解决争议的方法。\n当事人可以参照各类合同的示范文本订立合同。"];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string attributes:dic];
          CGSize attSize = [att boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        NSLog(@"%f",attSize.height);
        _textBody.attributedText = att;
        _textBody.frame = CGRectMake(20, 20, SCREEN_WIDTH-40, attSize.height);
        self.scrollView.contentSize = CGSizeMake(0, attSize.height+40);

    }
    return _textBody;
}
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView addSubview:self.textBody];

    }
    return _scrollView;
}
@end
