//
//  PartsRequestViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DetailPageBaseViewController.h"

@interface PartsRequestViewController : DetailPageBaseViewController


@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UITextField *textfield;

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *model;


@property (nonatomic, strong) NSString *FromUserID;
@property (nonatomic, strong) NSString *FromUserName;
@property (nonatomic, strong) NSString *ToUserID;
@property (nonatomic, strong) NSString *ToUserName;
@property (nonatomic, strong) NSString *HandlerID;
@property (nonatomic, strong) NSString *HandlerName;
@property (nonatomic, strong) NSString *ProductBreedID;
@property (nonatomic, strong) NSString *ProductType;

@property (nonatomic, strong) NSString *ProductClassify1ID;
@property (nonatomic, strong) NSString *ProductClassify2ID;

@property (nonatomic, strong) NSString *ProductClassify2Name;
@property (nonatomic, strong) NSString *WaiterName;
@end
