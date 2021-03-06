//
//  MyDefine.h
//  天气
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 apple1. All rights reserved.
//
//  真的只是局内人看不透吗？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？

#ifndef MyDefine_h
#define MyDefine_h

//系统版本
#define iOSVerson                         [[UIDevice currentDevice] systemVersion].floatValue

// 宽度
#define  Width                             [UIScreen mainScreen].bounds.size.width

// 高度
#define  Height                            [UIScreen mainScreen].bounds.size.height

// 状态栏高度
#define  StatusBarHeight                   20.f

// 导航栏高度
#define  NavigationBarHeight               44.f

// 标签栏高度
#define  TabbarHeight                      49.f

// 状态栏高度 + 导航栏高度
#define  StatusBarAndNavigationBarHeight   (20.f + 44.f)
#define  SearchBarHeight                   44.f

#define  iPhone4_4s   (Width == 320.f && Height == 480.f ? YES : NO)
#define  iPhone5_5s   (Width == 320.f && Height == 568.f ? YES : NO)
#define  iPhone6      (Width == 375.f && Height == 667.f ? YES : NO)
#define  iPhone6_plus (Width == 414.f && Height == 736.f ? YES : NO)


#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define font(str) [UIFont systemFontOfSize:(str)]

#define PageCount 3

#define beautifulColor color(7, 33, 57, 1)
#define beautifulGray color(233, 229, 226, 1)
#define beautifulBlueColor color(0, 122, 255, 1)
#define RedColor color(231, 76, 60, 1)
#define BlueColor color(59, 165, 249, 1)
#define GrayColor color(241, 241, 241, 1)
#define GreenColor color(32, 208, 40, 1)
#define CZGreenColor color(40, 165, 211, 1)
#define WXGreenColor color(7, 169, 182, 1)
#define ALiBlueColor color(40, 117, 191, 1)
#define  MainBlueColor color(9, 152, 205, 1)
#define currentPageControlTintColor color(224, 226, 213, 1)

#define LoginColor color(11, 157, 235, 1)

#endif /* MyDefine_h */
