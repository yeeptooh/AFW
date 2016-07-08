//
//  DetailTaskPlanTableViewCell.m
//  WeiKe
//
//  Created by Ji_YuFeng on 15/11/26.
//  Copyright © 2015年 Ji_YuFeng. All rights reserved.
//

#import "DetailTaskPlanTableViewCell.h"

#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import "AFNetworking.h"
#import "UserModel.h"
@interface DetailTaskPlanTableViewCell ()
<
UIViewControllerTransitioningDelegate
>

@property (nonatomic, strong) CTCallCenter *callCenter;


@end
@implementation DetailTaskPlanTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)phoneButtonClicked:(UIButton *)sender {
    
    NSString *phoneString = [NSString stringWithFormat:@"telprompt://%@",self.phoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
    
    [self detectCall];
}


-(void)detectCall {
    __weak typeof(self)weakSelf = self;
    UserModel *userModel = [UserModel readUserModel];
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler=^(CTCall* call) {
        
        if (call.callState == CTCallStateDisconnected) {
             //挂断
            
        }else if (call.callState == CTCallStateConnected) {
             //连通了
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSString *url = [NSString stringWithFormat:@"%@Task.ashx?action=callphone",HomeURL];
            NSDictionary *parameters = @{
                                         @"taskId":weakSelf.taskId,
                                         @"waitername":userModel.name,
                                         @"phone":weakSelf.phone
                                         };
            [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error = %@",error.userInfo);
            }];
            
        }else if(call.callState == CTCallStateIncoming) {
            
        }else if (call.callState ==CTCallStateDialing) {
              //拨号
        }else {
            
        }
    };
}



- (IBAction)messageButtonClicked:(UIButton *)sender {
    
    NSString *messageString = [NSString stringWithFormat:@"sms://%@",self.phoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:messageString]];
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
