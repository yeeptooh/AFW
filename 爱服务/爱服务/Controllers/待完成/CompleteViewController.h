//
//  CompleteViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ReturnParts)(NSString *orderID, NSString *brand, NSString *type, NSString *model, NSString *FromUserID, NSString *FromUserName, NSString *ToUserID, NSString *ToUserName, NSString *HandlerID, NSString *HandlerName, NSString *ProductBreedID,NSString *ProductClassify1ID, NSString *ProductClassify2ID, NSString *ProductClassify2Name, NSString *WaiterName);
typedef void(^ReturnAppend)(NSString *taskID, NSString *name, NSString *address, NSString *product, NSString *price);

@interface CompleteViewController : BaseViewController
@property (nonatomic, copy) ReturnParts returnParts;
@property (nonatomic, copy) ReturnAppend returnAppend;

@end
