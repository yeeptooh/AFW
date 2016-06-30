//
//  DialogViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/6/29.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogViewController : UIViewController
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *dialogList;
@property (nonatomic, strong) NSString *taskID;
@property (nonatomic, strong) NSString *fromUserID;
@property (nonatomic, strong) NSString *fromUserName;
@property (nonatomic, strong) NSString *toUserID;
@property (nonatomic, strong) NSString *toUserName;
@end
