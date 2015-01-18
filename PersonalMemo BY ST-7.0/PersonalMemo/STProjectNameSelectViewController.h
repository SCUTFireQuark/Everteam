//
//  STProjectNameSelectViewController.h
//  PersonalMemo
//
//  Created by st2 on 15/1/15.
//  Copyright (c) 2015年 st. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TaskMemoViewController.h"

@interface STProjectNameSelectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *Scro;
@property TaskMemoViewController * taskView;

@property (strong) NSString * tasksummary;
@property (strong) NSString * taskdetail;
@property (strong) NSString * taskdeadline;

-(void)printProject:(NSMutableDictionary *)dic;
-(void)disMissSelf;
@end
