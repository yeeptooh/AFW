//
//  ProductDetailTableView.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/23.
//  Copyright © 2016年 张冬冬. All rights reserved.
//


#import "ProductDetailTableView.h"
#import "DatePickerViewController.h"
#import "ProductTypeViewController.h"
#import "ProductClassifyBigViewController.h"
#import "ProductClassifySmallViewController.h"
#import "BaoXiuViewController.h"
#import "UserModel.h"
#import "AFNetworking.h"


@interface ProductDetailTableView ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>
@property (nonatomic, assign) CGRect baseFrame;


@property (nonatomic, strong) NSMutableArray *typeList;
@property (nonatomic, strong) NSMutableArray *typeIDList;
@property (nonatomic, strong) NSMutableArray *bigList;
@property (nonatomic, strong) NSMutableArray *bigIDList;
@property (nonatomic, strong) NSMutableArray *smallList;
@property (nonatomic, strong) NSMutableArray *smallIDList;

@property (nonatomic, strong) NSString *bigID;
@property (nonatomic, strong) NSString *smallID;





@end

@implementation ProductDetailTableView

- (NSMutableArray *)typeList {
    if (!_typeList) {
        _typeList = [NSMutableArray array];
    }
    return _typeList;
}

- (NSMutableArray *)typeIDList {
    if (!_typeIDList) {
        _typeIDList = [NSMutableArray array];
        
    }
    return _typeIDList;
}

- (NSMutableArray *)bigList {
    if (!_bigList) {
        _bigList = [NSMutableArray array];
    }
    return _bigList;
}

- (NSMutableArray *)bigIDList {
    if (!_bigIDList) {
        _bigIDList = [NSMutableArray array];
        
    }return _bigIDList;
}

- (NSMutableArray *)smallList {
    if (!_smallList) {
        _smallList = [NSMutableArray array];
    }
    return _smallList;
}

- (NSMutableArray *)smallIDList {
    if (!_smallIDList) {
        _smallIDList = [NSMutableArray array];
    }return _smallIDList;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.baseFrame = frame;
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.backgroundColor = color(241, 241, 241, 1);
        self.tableFooterView = [[UIView alloc]init];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self netWorkingRequest];
    }
    
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (Height - StatusBarAndNavigationBarHeight)/11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *labelList = @[@"商品属性",
                           @"商品大类",
                           @"商品小类",
                           @"产品型号",
                           @"保修性质",
                           @"购买时间",
                           ];
    static NSString *identifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, Width/4, (Height - StatusBarAndNavigationBarHeight)/11 - 10)];
    label.text = labelList[indexPath.row];
    CGFloat fontsize;
    if (iPhone4_4s || iPhone5_5s) {
        fontsize = 14;
    }else {
        fontsize = 16;
    }
    label.font = [UIFont systemFontOfSize:fontsize];
    label.textAlignment = NSTextAlignmentRight;
    
    cell.backgroundColor = [UIColor clearColor];
    [cell addSubview:label];
    
    if (indexPath.row == 3) {
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(Width *5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/11 - 10)];
        
        textfield.font = [UIFont systemFontOfSize:14];
        textfield.layer.cornerRadius = 5;
        textfield.layer.masksToBounds = YES;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.delegate = self;
        textfield.returnKeyType = UIReturnKeyDone;
        
        //tag = 103
        textfield.tag = 100 + indexPath.row;
        [cell addSubview:textfield];
    }
    if (indexPath.row != 3) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(Width *5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/11 - 10);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor whiteColor];
        button.tag = indexPath.row + 200;
        //tag = 200 || 201 || 202 || 204 || 205
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"]) {
            if (indexPath.row == 0) {
                [button setTitle:@"" forState:UIControlStateNormal];
            }else if (indexPath.row == 1) {
                [button setTitle:@"" forState:UIControlStateNormal];
            }else if (indexPath.row == 2) {
                [button setTitle:@"" forState:UIControlStateNormal];
            }
        }else {
            if (indexPath.row == 0) {
                [button setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"type"][0][@"n"] forState:UIControlStateNormal];
            }else if (indexPath.row == 1) {
                [button setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"big"][0][@"n"] forState:UIControlStateNormal];
            }else if (indexPath.row == 2) {
                [button setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"small"][0][@"n"] forState:UIControlStateNormal];
            }
        }
        
        if (indexPath.row == 4) {
            [button setTitle:@"保内" forState:UIControlStateNormal];
        }
        
        
        if (indexPath.row == 5) {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [formatter stringFromDate:date];
            
            [button setTitle:dateString forState:UIControlStateNormal];
        }
        
        
        
    }    return cell;
}

- (void)buttonClicked:(UIButton *)sender {
    [self endEditing:YES];
    UserModel *userModel = [UserModel readUserModel];
    if (sender.tag == 200) {
        ProductTypeViewController *typeVC = [[ProductTypeViewController alloc] init];
        typeVC.List = self.typeList;
        typeVC.returnInfo = ^(NSString *name, NSInteger row){
            [sender setTitle:name forState:UIControlStateNormal];
            self.FtypeID = self.typeIDList[row];
            NSString *bigUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getproductclassify&comid=%@&uid=%@&breedid=%@",HomeURL,@(userModel.comid),@(userModel.uid),self.typeIDList[row]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:bigUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                UIButton *button = [self viewWithTag:201];
                NSString *name;
                if ([(NSDictionary *)responseObject count] != 0) {
                    name = responseObject[0][@"n"];
                    self.bigID = [NSString stringWithFormat:@"%@",responseObject[0][@"c"]];
                }else {
                    name = @"";
                    self.bigID = @"bitch";
                }
                
                self.FbigID = self.bigID;
                [button setTitle:name forState:UIControlStateNormal];
                if (self.bigList.count != 0) {
                    [self.bigList removeAllObjects];
                }
                if (self.bigIDList.count != 0) {
                    [self.bigIDList removeAllObjects];
                }
                for (NSDictionary *dic in responseObject) {
                    [self.bigList addObject:dic[@"n"]];
                    [self.bigIDList addObject:dic[@"c"]];
                }
                
                
                NSString *bigUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getproductclassify2&comid=%@&uid=%@&parent=%@",HomeURL,@(userModel.comid),@(userModel.uid),self.bigIDList[0]];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                if (![self.bigID isEqualToString:@"bitch"]) {
                    [manager GET:bigUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        UIButton *button = [self viewWithTag:202];
                        NSString *name;
                        if ([(NSDictionary *)responseObject count] != 0) {
                            name = responseObject[0][@"n"];
                            self.smallID = [NSString stringWithFormat:@"%@",responseObject[0][@"c"]];
                        }else {
                            name = @"";
                            self.smallID = @"bitch";
                        }
                        self.FsmallID = self.smallID;
                        [button setTitle:name forState:UIControlStateNormal];
                        if (self.smallList.count != 0) {
                            [self.smallList removeAllObjects];
                        }
                        if (self.smallIDList.count != 0) {
                            [self.smallIDList removeAllObjects];
                        }
                        
                        for (NSDictionary *dic in responseObject) {
                            [self.smallList addObject:dic[@"n"]];
                            [self.smallIDList addObject:dic[@"c"]];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                    }];
                }else {
                     UIButton *button = [self viewWithTag:202];
                    [button setTitle:@"" forState:UIControlStateNormal];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        };
        
        [[self viewController] presentViewController:typeVC animated:YES completion:nil];
        
        
    }else if (sender.tag == 201) {
        
        ProductClassifyBigViewController *bigVC = [[ProductClassifyBigViewController alloc] init];
        bigVC.List = self.bigList;
        bigVC.returnInfo = ^(NSString *name, NSInteger row){
            
            [sender setTitle:name forState:UIControlStateNormal];
            self.FbigID = self.bigIDList[row];
            NSString *bigUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getproductclassify2&comid=%@&uid=%@&parent=%@",HomeURL,@(userModel.comid),@(userModel.uid),self.bigIDList[row]];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager GET:bigUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                UIButton *button = [self viewWithTag:202];
                NSString *name;
                if ([(NSDictionary *)responseObject count] != 0) {
                    name = responseObject[0][@"n"];
                    self.smallID = [NSString stringWithFormat:@"%@",responseObject[0][@"c"]];
                }else {
                    name = @"";
                    self.smallID = @"bitch";
                }
                self.FsmallID = self.smallID;
                [button setTitle:name forState:UIControlStateNormal];
                if (self.smallList.count != 0) {
                    [self.smallList removeAllObjects];
                }
                if (self.smallIDList.count != 0) {
                    [self.smallIDList removeAllObjects];
                }
                
                for (NSDictionary *dic in responseObject) {
                    [self.smallList addObject:dic[@"n"]];
                    [self.smallIDList addObject:dic[@"c"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
        };
        
        [[self viewController] presentViewController:bigVC animated:YES completion:nil];
        
    }else if (sender.tag == 202) {
        ProductClassifySmallViewController *smallVC = [[ProductClassifySmallViewController alloc] init];
        smallVC.List = self.smallList;
        smallVC.returnInfo = ^(NSString *name, NSInteger row){
            [sender setTitle:name forState:UIControlStateNormal];
            self.FsmallID = self.smallIDList[row];
        };
        
        [[self viewController] presentViewController:smallVC animated:YES completion:nil];
        
    }else if (sender.tag == 204) {
        BaoXiuViewController *bxVC = [[BaoXiuViewController alloc] init];
        bxVC.List = [NSMutableArray arrayWithArray:@[@"保内",@"保外"]];
        bxVC.returnInfo = ^(NSString *name, NSInteger row) {
            [sender setTitle:name forState:UIControlStateNormal];
            if (row == 0) {
                self.baoxiuIndex = 1;
            }else {
                self.baoxiuIndex = 0;
            }
        };
        
        [[self viewController] presentViewController:bxVC animated:YES completion:nil];
        
    }else {
        DatePickerViewController *datePickerVC = [[DatePickerViewController alloc]init];
        
        datePickerVC.returnDate = ^(NSString *dateStr){
            NSString *year = [dateStr substringToIndex:4];
            NSString *month = [dateStr substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [dateStr substringFromIndex:8];
            
            NSString *date = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            
            [sender setTitle:date forState:UIControlStateNormal];
        };
        
        [[self viewController] presentViewController:datePickerVC animated:YES completion:nil];

    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}



- (void)netWorkingRequest {
    self.baoxiuIndex = 1;
    UserModel *userModel = [UserModel readUserModel];
    NSString *typeUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getproductbree&comid=%@&uid=%@",HomeURL,@(userModel.comid),@(userModel.uid)];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:typeUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"type"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (NSDictionary *dic in responseObject) {
            [self.typeList addObject:dic[@"n"]];
            [self.typeIDList addObject:dic[@"c"]];
        }
        self.FtypeID = self.typeIDList[0];
        
        NSString *bigUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getproductclassify&comid=%@&uid=%@&breedid=%@",HomeURL,@(userModel.comid),@(userModel.uid),self.typeIDList[0]];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager GET:bigUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"big"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            for (NSDictionary *dic in responseObject) {
                [self.bigList addObject:dic[@"n"]];
                [self.bigIDList addObject:dic[@"c"]];
            }
            self.FbigID = self.bigIDList[0];
            
            NSString *bigUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getproductclassify2&comid=%@&uid=%@&parent=%@",HomeURL,@(userModel.comid),@(userModel.uid),self.bigIDList[0]];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:bigUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"small"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                for (NSDictionary *dic in responseObject) {
                    [self.smallList addObject:dic[@"n"]];
                    [self.smallIDList addObject:dic[@"c"]];
                }
                
                self.FsmallID = self.smallIDList[0];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
 
    
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



@end

