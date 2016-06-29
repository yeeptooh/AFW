//
//  ProductDetailTableView.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/23.
//  Copyright © 2016年 张冬冬. All rights reserved.
//


#import "BusinessDetailTableView.h"
#import "DatePickerViewController.h"
#import "ServiceTypeViewController.h"
#import "AFNetworking.h"
@interface BusinessDetailTableView ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>
@property (nonatomic, assign) CGRect baseFrame;

@property (nonatomic, strong) NSMutableArray *servceList;
@property (nonatomic, strong) NSMutableArray *serviceIDList;


@end

@implementation BusinessDetailTableView

- (NSMutableArray *)servceList {
    if (!_servceList) {
        _servceList = [NSMutableArray array];
    }
    return _servceList;
}

- (NSMutableArray *)serviceIDList {
    if (!_serviceIDList) {
        _serviceIDList = [NSMutableArray array];
    }
    return _serviceIDList;
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (Height - StatusBarAndNavigationBarHeight)/11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *labelList = @[@"服务类型",
                           @"预约时间",
                           @"备注",
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
    
    if (indexPath.row == 2) {
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(Width *5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/11 - 10)];
        
        textfield.font = [UIFont systemFontOfSize:14];
        textfield.layer.cornerRadius = 5;
        textfield.layer.masksToBounds = YES;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.delegate = self;
        textfield.returnKeyType = UIReturnKeyDone;
        
        //tag = 102
        textfield.tag = 100 + indexPath.row;
        [cell addSubview:textfield];
    }
    if (indexPath.row >= 0 && indexPath.row <= 1) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(Width *5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/11 - 10);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor whiteColor];
        button.tag = indexPath.row + 200;
        //tag = 200 || 201
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"]) {
            if (indexPath.row == 0) {
                [button setTitle:@"" forState:UIControlStateNormal];
            }
        }else {
            if (indexPath.row == 0) {
                NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"service"][0][@"n"];
                
                [button setTitle:name forState:UIControlStateNormal];
            }
        }
        
        if (indexPath.row == 1) {
            
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [formatter stringFromDate:date];
            
            [button setTitle:dateString forState:UIControlStateNormal];
        }
        
    }
    return cell;
}

- (void)buttonClicked:(UIButton *)sender {
    [self endEditing:YES];
    if (sender.tag == 200) {
        
        ServiceTypeViewController *serviceVC = [[ServiceTypeViewController alloc] init];
        serviceVC.List = self.servceList;
        serviceVC.returnInfo = ^(NSString *name, NSInteger row){
            [sender setTitle:name forState:UIControlStateNormal];
            self.serviceID = [self.serviceIDList[row] integerValue];
        };
        [[self viewController] presentViewController:serviceVC animated:YES completion:nil];
        
        
    }else if (sender.tag == 201) {
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
    NSString *typeUrl = [NSString stringWithFormat:@"%@Common.ashx?action=getservicetype",HomeURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:typeUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"service"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (NSDictionary *dic in responseObject) {
            [self.servceList addObject:dic[@"n"]];
            [self.serviceIDList addObject:dic[@"c"]];
        }
        self.serviceID = [self.serviceIDList[0] integerValue];
        NSLog(@"self.servceList = %@",self.servceList);
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

