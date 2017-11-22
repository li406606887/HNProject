//
//  PublishShareViewModel.h
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface PublishShareViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *publishShareCommand;//发布分享
@property(nonatomic,strong) RACSubject *publishShareSubject;//发布分享
@property(nonatomic,strong) RACSubject *shareCompleteSubject;//发布分享
@property(nonatomic,strong) RACSubject *readPromptSubject;//阅读提示;
@property(nonatomic,copy) NSString* shareTitle;
@property(nonatomic,copy) NSString* shareContent;
@property(nonatomic,copy) NSString* shareImage;
@property(nonatomic,copy) NSArray * imageArray;

@end
