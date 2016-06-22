//
//  UserDetailTableView.h
//  爱服务
//
//  Created by 张冬冬 on 16/6/22.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailTableView : UITableView
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>

@property (nonatomic, assign) CGRect baseFrame;
@end
