//
//  STUserSelectedViewController.h
//  PersonalMemo
//
//  Created by st2 on 15/1/15.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskMemoViewController.h"
#import "STProjectNameSelectViewController.h"
@interface STUserSelectedViewController : UIViewController
@property TaskMemoViewController * taskView;
@property (strong) NSString * tasksummary;
@property (strong) NSString * taskdetail;
@property (strong) NSString * taskdeadline;
@property STProjectNameSelectViewController * delegate_userSelected;
//显示一个project里面的user

-(void)printUser:(NSMutableDictionary *)dic;
@end
