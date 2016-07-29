//
//  ChangeImageViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/7/28.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DetailPageBaseViewController.h"

@interface ChangeImageViewController : DetailPageBaseViewController
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger uploadCount;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSString *taskID;
@property (nonatomic, assign, getter=isDisplay) BOOL display;
@end
