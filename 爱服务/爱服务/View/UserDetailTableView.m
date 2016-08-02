//
//  UserDetailTableView.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/22.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "UserDetailTableView.h"
#import "ProvinceViewController.h"
#import "CityViewController.h"
#import "RegionViewController.h"
#import "StreetViewController.h"
#import "ChangeOrderViewController.h"
#import "AFNetworking.h"

@interface UserDetailTableView ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>

@property (nonatomic, assign) CGRect baseFrame;

@property (nonatomic, strong) NSMutableArray *provinceList;
@property (nonatomic, strong) NSMutableArray *cityList;
@property (nonatomic, strong) NSMutableArray *regionList;
@property (nonatomic, strong) NSMutableArray *streetList;

@property (nonatomic, strong) NSString *provinceID;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *regionID;
@property (nonatomic, strong) NSString *streetID;

@property (nonatomic, strong) NSMutableArray *provinceIDList;
@property (nonatomic, strong) NSMutableArray *cityIDList;
@property (nonatomic, strong) NSMutableArray *regionIDList;
@property (nonatomic, strong) NSMutableArray *streetIDList;

@end

@implementation UserDetailTableView

- (NSMutableArray *)provinceList {
    if (!_provinceList) {
        _provinceList = [NSMutableArray array];
    }
    return _provinceList;
}


- (NSMutableArray *)cityList {
    if (!_cityList) {
        _cityList = [NSMutableArray array];
    }
    return _cityList;
}


-(NSMutableArray *)regionList {
    if (!_regionList) {
        _regionList = [NSMutableArray array];
    }
    return _regionList;
}

- (NSMutableArray *)streetList {
    if (!_streetList) {
        _streetList = [NSMutableArray array];
    }
    return _streetList;
}

- (NSMutableArray *)provinceIDList {
    if (!_provinceIDList) {
        _provinceIDList = [NSMutableArray array];
    }
    return _provinceIDList;
}


- (NSMutableArray *)cityIDList {
    if (!_cityIDList) {
        _cityIDList = [NSMutableArray array];
    }
    return _cityIDList;
}


-(NSMutableArray *)regionIDList {
    if (!_regionIDList) {
        _regionIDList = [NSMutableArray array];
    }
    return _regionIDList;
}

- (NSMutableArray *)streetIDList {
    if (!_streetIDList) {
        _streetIDList = [NSMutableArray array];
    }
    return _streetIDList;
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
        [self addKeyboardNotification];

        [self networking];
        
    }
    
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (Height - StatusBarAndNavigationBarHeight)/11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *labelList = @[
                           @"姓 名",
                           @"手 机",
                           @"省 份",
                           @"城 市",
                           @"市/县/区",
                           @"街 道",
                           @"详细地址"
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
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 6) {
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(Width *5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/11 - 10)];
        textfield.delegate = self;
        textfield.font = [UIFont systemFontOfSize:14];
        textfield.layer.cornerRadius = 5;
        textfield.layer.masksToBounds = YES;
        textfield.backgroundColor = [UIColor whiteColor];
        if (indexPath.row == 1) {
            textfield.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (indexPath.row != 6) {
            textfield.returnKeyType = UIReturnKeyNext;
        }else{
            textfield.returnKeyType = UIReturnKeyDone;
        }
        if (indexPath.row == 0) {
            textfield.text = self.name;
        }else if (indexPath.row == 1) {
            textfield.text = self.phone;
        }else {
            textfield.text = self.address;
        }
        //tag = 100 || 101 || 106
        textfield.tag = 100 + indexPath.row;
        [cell addSubview:textfield];
    }
    if (indexPath.row >= 2 && indexPath.row <= 5) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(Width *5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/11 - 10);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor whiteColor];
        button.tag = indexPath.row + 200;
        //tag = 202 || 203 || 204 || 205
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        
        if (indexPath.row == 2) {
            if ([[self viewController] isKindOfClass:[ChangeOrderViewController class]]) {
                [button setTitle:self.province forState:UIControlStateNormal];
            }else {
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FirstLaunch"]) {
                    [button setTitle:@"" forState:UIControlStateNormal];
                }else {
                    [button setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"province"][0][@"n"] forState:UIControlStateNormal];
                }
            }
            
        }
        
        if (indexPath.row == 3) {
            if ([[self viewController] isKindOfClass:[ChangeOrderViewController class]]) {
                [button setTitle:self.city forState:UIControlStateNormal];
            }else {
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FirstLaunch"]) {
                    [button setTitle:@"" forState:UIControlStateNormal];
                }else {
                    [button setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"city"][0][@"n"] forState:UIControlStateNormal];
                }
            }
            
        }
        
        if (indexPath.row == 4) {
            if ([[self viewController] isKindOfClass:[ChangeOrderViewController class]]) {
                [button setTitle:self.district forState:UIControlStateNormal];
            }else {
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FirstLaunch"]) {
                    [button setTitle:@"" forState:UIControlStateNormal];
                }else {
                    [button setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"region"][0][@"n"] forState:UIControlStateNormal];
                }
            }
        }
        
        if (indexPath.row == 5) {
            if ([[self viewController] isKindOfClass:[ChangeOrderViewController class]]) {
                [button setTitle:self.town forState:UIControlStateNormal];
            }else {
                if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FirstLaunch"]) {
                    [button setTitle:@"" forState:UIControlStateNormal];
                }else {
                    [button setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"street"][0][@"n"] forState:UIControlStateNormal];
                }
            }
        }
        
    }    return cell;
}



- (void)buttonClicked:(UIButton *)sender {
    [self endEditing:YES];
    if ([[self viewController] isKindOfClass:[ChangeOrderViewController class]]) {
        if (sender.tag == 202) {
            ProvinceViewController *provinceVC = [[ProvinceViewController alloc] init];
            provinceVC.List = self.provinceList;
            provinceVC.returnInfo = ^(NSString *name, NSInteger row){
                [sender setTitle:name forState:UIControlStateNormal];
                self.FprovinceID = self.provinceIDList[row];
                NSString *cityUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getcity&parent=%@",HomeURL,self.provinceIDList[row]];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager GET:cityUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    UIButton *button = [self viewWithTag:203];
                    NSString *name;
                    if ([(NSDictionary *)responseObject count] != 0) {
                        name = responseObject[0][@"n"];
                        self.cityID = responseObject[0][@"c"];
                    }else {
                        name = @"";
                        self.cityID = @"bitch";
                    }
                    self.FcityID = self.cityID;
                    [button setTitle:name forState:UIControlStateNormal];
                    if (self.cityList.count != 0) {
                        [self.cityList removeAllObjects];
                    }
                    if (self.cityIDList.count != 0) {
                        [self.cityIDList removeAllObjects];
                    }
                    for (NSDictionary *dic in responseObject) {
                        
                        [self.cityList addObject:dic[@"n"]];
                        [self.cityIDList addObject:dic[@"c"]];
                    }
                    
                    if (![self.cityID isEqualToString:@"bitch"]) {
                        
                        NSString *regionUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getdistricts&parent=%@",HomeURL,responseObject[0][@"c"]];
                        
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        
                        [manager GET:regionUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            UIButton *button = [self viewWithTag:204];
                            NSString *name;
                            
                            if ([(NSDictionary *)responseObject count] != 0) {
                                name = responseObject[0][@"n"];
                                self.regionID = responseObject[0][@"c"];
                            }else {
                                name = @"";
                                self.regionID = @"bitch";
                            }
                            self.FregionID = self.regionID;
                            if (self.regionList.count != 0) {
                                [self.regionList removeAllObjects];
                            }
                            if (self.regionIDList.count != 0) {
                                [self.regionIDList removeAllObjects];
                            }
                            for (NSDictionary *dic in responseObject) {
                                [self.regionList addObject:dic[@"n"]];
                                [self.regionIDList addObject:dic[@"c"]];
                            }
                            [button setTitle:name forState:UIControlStateNormal];
                            
                            if (![self.regionID isEqualToString:@"bitch"]) {
                                
                                NSString *streetUrl = [NSString stringWithFormat:@"%@Common.ashx?action=gettown&parent=%@",HomeURL,responseObject[0][@"c"]];
                                
                                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                
                                [manager GET:streetUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    
                                    UIButton *button = [self viewWithTag:205];
                                    NSString *name;
                                    //                                NSLog(@"%@",responseObject);
                                    
                                    if ([(NSDictionary *)responseObject count] != 0) {
                                        name = responseObject[0][@"n"];
                                        self.streetID = responseObject[0][@"c"];
                                    }else {
                                        name = @"";
                                        self.streetID = @"bitch";
                                    }
                                    self.FstreetID = self.streetID;
                                    if (self.streetList.count != 0) {
                                        [self.streetList removeAllObjects];
                                    }
                                    if (self.streetIDList.count != 0) {
                                        [self.streetIDList removeAllObjects];
                                    }
                                    for (NSDictionary *dic in responseObject) {
                                        [self.streetList addObject:dic[@"n"]];
                                        [self.streetIDList addObject:dic[@"c"]];
                                    }
                                    [button setTitle:name forState:UIControlStateNormal];
                                    
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                }];
                            }else {
                                UIButton *button = [self viewWithTag:205];
                                [button setTitle:@"" forState:UIControlStateNormal];
                            }
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                        }];
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
            };
            
            [[self viewController] presentViewController:provinceVC animated:YES completion:nil];
            
        }else if (sender.tag == 203) {
            
            CityViewController *cityVC = [[CityViewController alloc] init];
            NSString *cityUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getcity&parent=%@",HomeURL,self.FprovinceID];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:cityUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (self.cityList.count) {
                    [self.cityList removeAllObjects];
                }
                if (self.cityIDList.count) {
                    [self.cityIDList removeAllObjects];
                }
                
                for (NSDictionary *dic in responseObject) {
                    [self.cityList addObject:dic[@"n"]];
                    [self.cityIDList addObject:dic[@"c"]];
                }
                
                cityVC.List = self.cityList;
                cityVC.returnInfo = ^(NSString *name, NSInteger row){
                    [sender setTitle:name forState:UIControlStateNormal];

                    self.FcityID = self.cityIDList[row];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    NSString *regionUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getdistricts&parent=%@",HomeURL,self.FcityID];
                    [manager GET:regionUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        UIButton *button = [self viewWithTag:204];
                        NSString *name;
                        if ([(NSDictionary *)responseObject count] != 0) {
                            name = responseObject[0][@"n"];
                            self.regionID = responseObject[0][@"c"];
                        }else {
                            name = @"";
                            self.regionID = @"bitch";
                        }
                        self.FregionID = self.regionID;
                        if (self.regionList.count != 0) {
                            [self.regionList removeAllObjects];
                        }
                        if (self.regionIDList.count != 0) {
                            [self.regionIDList removeAllObjects];
                        }
                        
                        for (NSDictionary *dic in responseObject) {
                            [self.regionList addObject:dic[@"n"]];
                            [self.regionIDList addObject:dic[@"c"]];
                        }
                        [button setTitle:name forState:UIControlStateNormal];
                        
                        
                        if (![self.regionID isEqualToString:@"bitch"]) {
                            NSString *streetUrl = [NSString stringWithFormat:@"%@Common.ashx?action=gettown&parent=%@",HomeURL,self.regionIDList[0]];
                            
                            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                            
                            [manager GET:streetUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                UIButton *button = [self viewWithTag:205];
                                NSString *name;
                                
                                if ([(NSDictionary *)responseObject count] != 0) {
                                    name = responseObject[0][@"n"];
                                    self.streetID = responseObject[0][@"c"];
                                }else {
                                    name = @"";
                                    self.streetID = @"bitch";
                                }
                                self.FstreetID = self.streetID;
                                if (self.streetList.count != 0) {
                                    [self.streetList removeAllObjects];
                                }
                                if (self.streetIDList.count != 0) {
                                    [self.streetIDList removeAllObjects];
                                }
                                for (NSDictionary *dic in responseObject) {
                                    [self.streetList addObject:dic[@"n"]];
                                    [self.streetIDList addObject:dic[@"c"]];
                                }
                                [button setTitle:name forState:UIControlStateNormal];
                                
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                
                            }];
                        }else {
                            UIButton *button = [self viewWithTag:205];
                            [button setTitle:@"" forState:UIControlStateNormal];
                        }
                        
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                    }];
                    
                };
                
                [[self viewController] presentViewController:cityVC animated:YES completion:nil];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        }else if (sender.tag == 204) {
            RegionViewController *regionVC = [[RegionViewController alloc] init];
            NSString *regionUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getdistricts&parent=%@",HomeURL,self.FcityID];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:regionUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                if (self.regionList.count) {
                    [self.regionList removeAllObjects];
                }
                
                if (self.regionIDList.count) {
                    [self.regionIDList removeAllObjects];
                }
                
                for (NSDictionary *dic in responseObject) {
                    [self.regionList addObject:dic[@"n"]];
                    [self.regionIDList addObject:dic[@"c"]];
                }
                
                regionVC.List = self.regionList;
                regionVC.returnInfo = ^(NSString *name, NSInteger row){
                    [sender setTitle:name forState:UIControlStateNormal];
                    
                    if (![self.regionID isEqualToString:@"bitch"]) {
                        NSString *streetUrl = [NSString stringWithFormat:@"%@Common.ashx?action=gettown&parent=%@",HomeURL,self.regionIDList[row]];
                        self.FregionID = self.regionIDList[row];
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        
                        [manager GET:streetUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            NSLog(@"%@",responseObject);
                            UIButton *button = [self viewWithTag:205];
                            NSString *name;
                            
                            
                            if ([(NSDictionary *)responseObject count] != 0) {
                                name = responseObject[0][@"n"];
                                self.streetID = responseObject[0][@"c"];
                            }else {
                                name = @"";
                                self.streetID = @"bitch";
                            }
                            self.FstreetID = self.streetID;
                            if (self.streetList.count != 0) {
                                [self.streetList removeAllObjects];
                            }
                            if (self.streetIDList.count != 0) {
                                [self.streetIDList removeAllObjects];
                            }
                            for (NSDictionary *dic in responseObject) {
                                [self.streetList addObject:dic[@"n"]];
                                [self.streetIDList addObject:dic[@"c"]];
                            }
                            [button setTitle:name forState:UIControlStateNormal];
                            
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                        }];
                    }else{
                        UIButton *button = [self viewWithTag:205];
                        [button setTitle:@"" forState:UIControlStateNormal];
                    }
                    
                };
                
                [[self viewController] presentViewController:regionVC animated:YES completion:nil];

                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
        }else {
            StreetViewController *streetVC = [[StreetViewController alloc] init];
            streetVC.List = self.streetList;
            streetVC.returnInfo = ^(NSString *name, NSInteger row){
                self.FstreetID = self.streetIDList[row];
                [sender setTitle:name forState:UIControlStateNormal];
                
            };
            
            [[self viewController] presentViewController:streetVC animated:YES completion:nil];
        }
    }else {
        if (sender.tag == 202) {
            ProvinceViewController *provinceVC = [[ProvinceViewController alloc] init];
            provinceVC.List = self.provinceList;
            provinceVC.returnInfo = ^(NSString *name, NSInteger row){
                [sender setTitle:name forState:UIControlStateNormal];
                self.FprovinceID = self.provinceIDList[row];
                NSString *cityUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getcity&parent=%@",HomeURL,self.provinceIDList[row]];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager GET:cityUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    UIButton *button = [self viewWithTag:203];
                    NSString *name;
                    if ([(NSDictionary *)responseObject count] != 0) {
                        name = responseObject[0][@"n"];
                        self.cityID = responseObject[0][@"c"];
                    }else {
                        name = @"";
                        self.cityID = @"bitch";
                    }
                    self.FcityID = self.cityID;
                    [button setTitle:name forState:UIControlStateNormal];
                    if (self.cityList.count != 0) {
                        [self.cityList removeAllObjects];
                    }
                    if (self.cityIDList.count != 0) {
                        [self.cityIDList removeAllObjects];
                    }
                    for (NSDictionary *dic in responseObject) {
                        
                        [self.cityList addObject:dic[@"n"]];
                        [self.cityIDList addObject:dic[@"c"]];
                    }
                    
                    if (![self.cityID isEqualToString:@"bitch"]) {
                        
                        NSString *regionUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getdistricts&parent=%@",HomeURL,responseObject[0][@"c"]];
                        
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        
                        [manager GET:regionUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            UIButton *button = [self viewWithTag:204];
                            NSString *name;
                            
                            if ([(NSDictionary *)responseObject count] != 0) {
                                name = responseObject[0][@"n"];
                                self.regionID = responseObject[0][@"c"];
                            }else {
                                name = @"";
                                self.regionID = @"bitch";
                            }
                            self.FregionID = self.regionID;
                            if (self.regionList.count != 0) {
                                [self.regionList removeAllObjects];
                            }
                            if (self.regionIDList.count != 0) {
                                [self.regionIDList removeAllObjects];
                            }
                            for (NSDictionary *dic in responseObject) {
                                [self.regionList addObject:dic[@"n"]];
                                [self.regionIDList addObject:dic[@"c"]];
                            }
                            [button setTitle:name forState:UIControlStateNormal];
                            
                            if (![self.regionID isEqualToString:@"bitch"]) {
                                
                                NSString *streetUrl = [NSString stringWithFormat:@"%@Common.ashx?action=gettown&parent=%@",HomeURL,responseObject[0][@"c"]];
                                
                                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                
                                [manager GET:streetUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    
                                    UIButton *button = [self viewWithTag:205];
                                    NSString *name;
                                    //                                NSLog(@"%@",responseObject);
                                    
                                    if ([(NSDictionary *)responseObject count] != 0) {
                                        name = responseObject[0][@"n"];
                                        self.streetID = responseObject[0][@"c"];
                                    }else {
                                        name = @"";
                                        self.streetID = @"bitch";
                                    }
                                    self.FstreetID = self.streetID;
                                    if (self.streetList.count != 0) {
                                        [self.streetList removeAllObjects];
                                    }
                                    if (self.streetIDList.count != 0) {
                                        [self.streetIDList removeAllObjects];
                                    }
                                    for (NSDictionary *dic in responseObject) {
                                        [self.streetList addObject:dic[@"n"]];
                                        [self.streetIDList addObject:dic[@"c"]];
                                    }
                                    [button setTitle:name forState:UIControlStateNormal];
                                    
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                }];
                            }else {
                                UIButton *button = [self viewWithTag:205];
                                [button setTitle:@"" forState:UIControlStateNormal];
                            }
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                        }];
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
            };
            
            [[self viewController] presentViewController:provinceVC animated:YES completion:nil];
            
        }else if (sender.tag == 203) {
            CityViewController *cityVC = [[CityViewController alloc] init];
            cityVC.List = self.cityList;
            cityVC.returnInfo = ^(NSString *name, NSInteger row){
                [sender setTitle:name forState:UIControlStateNormal];
                
                NSString *regionUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getdistricts&parent=%@",HomeURL,self.cityIDList[row]];
                self.FcityID = self.cityIDList[row];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                [manager GET:regionUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    UIButton *button = [self viewWithTag:204];
                    NSString *name;
                    if ([(NSDictionary *)responseObject count] != 0) {
                        name = responseObject[0][@"n"];
                        self.regionID = responseObject[0][@"c"];
                    }else {
                        name = @"";
                        self.regionID = @"bitch";
                    }
                    self.FregionID = self.regionID;
                    if (self.regionList.count != 0) {
                        [self.regionList removeAllObjects];
                    }
                    if (self.regionIDList.count != 0) {
                        [self.regionIDList removeAllObjects];
                    }
                    
                    for (NSDictionary *dic in responseObject) {
                        [self.regionList addObject:dic[@"n"]];
                        [self.regionIDList addObject:dic[@"c"]];
                    }
                    [button setTitle:name forState:UIControlStateNormal];
                    
                    
                    if (![self.regionID isEqualToString:@"bitch"]) {
                        NSString *streetUrl = [NSString stringWithFormat:@"%@Common.ashx?action=gettown&parent=%@",HomeURL,responseObject[0][@"c"]];
                        
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        
                        [manager GET:streetUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            UIButton *button = [self viewWithTag:205];
                            NSString *name;
                            //                        NSLog(@"%@",responseObject);
                            
                            if ([(NSDictionary *)responseObject count] != 0) {
                                name = responseObject[0][@"n"];
                                self.streetID = responseObject[0][@"c"];
                            }else {
                                name = @"";
                                self.streetID = @"bitch";
                            }
                            self.FstreetID = self.streetID;
                            if (self.streetList.count != 0) {
                                [self.streetList removeAllObjects];
                            }
                            if (self.streetIDList.count != 0) {
                                [self.streetIDList removeAllObjects];
                            }
                            for (NSDictionary *dic in responseObject) {
                                [self.streetList addObject:dic[@"n"]];
                                [self.streetIDList addObject:dic[@"c"]];
                            }
                            [button setTitle:name forState:UIControlStateNormal];
                            
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                        }];
                    }else {
                        UIButton *button = [self viewWithTag:205];
                        [button setTitle:@"" forState:UIControlStateNormal];
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
            };
            
            [[self viewController] presentViewController:cityVC animated:YES completion:nil];
            
        }else if (sender.tag == 204) {
            RegionViewController *regionVC = [[RegionViewController alloc] init];
            regionVC.List = self.regionList;
            regionVC.returnInfo = ^(NSString *name, NSInteger row){
                [sender setTitle:name forState:UIControlStateNormal];
                
                if (![self.regionID isEqualToString:@"bitch"]) {
                    NSString *streetUrl = [NSString stringWithFormat:@"%@Common.ashx?action=gettown&parent=%@",HomeURL,self.regionIDList[row]];
                    self.FregionID = self.regionIDList[row];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    
                    [manager GET:streetUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"%@",responseObject);
                        UIButton *button = [self viewWithTag:205];
                        NSString *name;
                        
                        
                        if ([(NSDictionary *)responseObject count] != 0) {
                            name = responseObject[0][@"n"];
                            self.streetID = responseObject[0][@"c"];
                        }else {
                            name = @"";
                            self.streetID = @"bitch";
                        }
                        self.FstreetID = self.streetID;
                        if (self.streetList.count != 0) {
                            [self.streetList removeAllObjects];
                        }
                        if (self.streetIDList.count != 0) {
                            [self.streetIDList removeAllObjects];
                        }
                        for (NSDictionary *dic in responseObject) {
                            [self.streetList addObject:dic[@"n"]];
                            [self.streetIDList addObject:dic[@"c"]];
                        }
                        [button setTitle:name forState:UIControlStateNormal];
                        
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                    }];
                }else{
                    UIButton *button = [self viewWithTag:205];
                    [button setTitle:@"" forState:UIControlStateNormal];
                }
                
            };
            
            [[self viewController] presentViewController:regionVC animated:YES completion:nil];
            
        }else {
            StreetViewController *streetVC = [[StreetViewController alloc] init];
            streetVC.List = self.streetList;
            streetVC.returnInfo = ^(NSString *name, NSInteger row){
                self.FstreetID = self.streetIDList[row];
                [sender setTitle:name forState:UIControlStateNormal];
                
            };
            
            [[self viewController] presentViewController:streetVC animated:YES completion:nil];
            
        }
    }
}


- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    UITextField *textField = (UITextField *)[self viewWithTag:106];
    if ([textField isFirstResponder]) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = frame.origin.y - 120;
            
            self.frame = frame;
        }];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)noti {
    UITextField *textField = (UITextField *)[self viewWithTag:106];
    if ([textField isFirstResponder]) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.frame = self.baseFrame;
        }];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 106) {
        [self endEditing:YES];
    }else{
        
        if (textField.tag == 101) {
            UITextField *lastTextField = (UITextField *)[self viewWithTag:textField.tag];
            [lastTextField resignFirstResponder];
            UITextField *nextTextField = (UITextField *)[self viewWithTag:106];
            [nextTextField becomeFirstResponder];
        }else{
            UITextField *lastTextField = (UITextField *)[self viewWithTag:textField.tag];
            [lastTextField resignFirstResponder];
            
            UITextField *nextTextField = (UITextField *)[self viewWithTag:textField.tag + 1];
            [nextTextField becomeFirstResponder];
        }
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)networking {
    
    NSString *provinceUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getprovince",HomeURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:provinceUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"province"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (NSDictionary *dic in responseObject) {
            [self.provinceList addObject:dic[@"n"]];
            [self.provinceIDList addObject:dic[@"c"]];
        }
        
        self.provinceID = self.provinceIDList[0];
        self.YprovinceID = self.provinceIDList[0];
        NSString *cityUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getcity&parent=%@",HomeURL,self.provinceIDList[0]];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:cityUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"city"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            for (NSDictionary *dic in responseObject) {
                [self.cityList addObject:dic[@"n"]];
                [self.cityIDList addObject:dic[@"c"]];
            }
            self.cityID = self.cityIDList[0];
            self.YcityID = self.cityIDList[0];
            NSString *regionUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getdistricts&parent=%@",HomeURL,self.cityIDList[0]];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager GET:regionUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"region"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                for (NSDictionary *dic in responseObject) {
                    [self.regionList addObject:dic[@"n"]];
                    [self.regionIDList addObject:dic[@"c"]];
                }
                
                self.regionID = self.regionIDList[0];
                self.YregionID = self.regionIDList[0];
                NSString *streetUrl = [NSString stringWithFormat:@"%@Common.ashx?action=gettown&parent=%@",HomeURL,self.regionIDList[0]];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                [manager GET:streetUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"street"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    for (NSDictionary *dic in responseObject) {
                        [self.streetList addObject:dic[@"n"]];
                        [self.streetIDList addObject:dic[@"c"]];
                    }
                    self.streetID = self.streetIDList[0];
                    self.YstreetID = self.streetIDList[0];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
                
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
